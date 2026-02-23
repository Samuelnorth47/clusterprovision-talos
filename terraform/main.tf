module "talos_cp_nodes" {
  source           = "./modules/proxmox_terraform_vm"
  for_each         = var.cp_nodes
  name             = each.key
  node_name        = each.value.node_name
  cores            = each.value.cores
  memory_mb        = each.value.memory_mb
  bridge           = var.bridge
  iso_download_url = var.iso_url
  disk_size        = var.disk_size
  disk_datastore   = var.disk_datastore
}

module "talos_worker_nodes" {
  source           = "./modules/proxmox_terraform_vm"
  for_each         = var.worker_nodes
  name             = each.key
  node_name        = each.value.node_name
  cores            = each.value.cores
  memory_mb        = each.value.memory_mb
  bridge           = var.bridge
  iso_download_url = var.iso_url
  disk_size        = var.disk_size
  disk_datastore   = var.disk_datastore
}

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes = [for node in module.talos_cp_nodes : node.vm_ipv4_addresses[0]]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  for_each                    = module.talos_cp_nodes
  node                        = each.value.vm_ipv4_addresses[0]
  config_patches = [
    templatefile("${path.module}/templates/global.yaml.tmpl", {
      hostname          = each.key
      install_disk      = var.install_disk
      gateway           = var.gateway
      cluster_vip       = var.cluster_vip
      schematic_id      = var.schematic_id
      talos_version     = var.talos_version
      network_interface = var.network_interface
      nameservers       = var.nameservers
      search_domains    = var.search_domains
    }),
    file("${path.module}/files/cp.yaml"),
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  for_each                    = module.talos_worker_nodes
  node                        = each.value.vm_ipv4_addresses[0]
  config_patches = [
    templatefile("${path.module}/templates/global.yaml.tmpl", {
      hostname          = each.key
      install_disk      = var.install_disk
      gateway           = var.gateway
      cluster_vip       = var.cluster_vip
      schematic_id      = var.schematic_id
      talos_version     = var.talos_version
      network_interface = var.network_interface
      nameservers       = var.nameservers
      search_domains    = var.search_domains
    })
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node = module.talos_cp_nodes[keys(var.cp_nodes)[0]].vm_ipv4_addresses[0]
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node = module.talos_cp_nodes[keys(var.cp_nodes)[0]].vm_ipv4_addresses[0]
}

resource "local_sensitive_file" "talosconfig" {
  content  = data.talos_client_configuration.this.talos_config
  filename = "/opt/kubernetes/talosconfig"
}

resource "local_sensitive_file" "kubeconfig" {
  content  = talos_cluster_kubeconfig.this.kubeconfig_raw
  filename = "/opt/kubernetes/kubeconfig"
}
