module "proxmox_talos_master_1" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "master-1"
  node_name      = "venus"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  memory_mb      = 13312
  cores          = 7
  bridge         = "vmbr0"
  iso_download_url = "https://factory.talos.dev/image/914b38adefad3d77212f565745ed52013bf3a424e7da2730e9e7dad8ee297342/v1.12.4/metal-amd64.iso"
}

module "proxmox_talos_master_2" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "master-2"
  node_name      = "saturn"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  memory_mb      = 13312
  cores          = 11
  bridge         = "vmbr0"
  iso_download_url = "https://factory.talos.dev/image/914b38adefad3d77212f565745ed52013bf3a424e7da2730e9e7dad8ee297342/v1.12.4/metal-amd64.iso"
}

module "proxmox_talos_master_3" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "master-3"
  node_name      = "mercury"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  memory_mb      = 10240
  cores          = 6
  bridge         = "vmbr0"
  iso_download_url = "https://factory.talos.dev/image/914b38adefad3d77212f565745ed52013bf3a424e7da2730e9e7dad8ee297342/v1.12.4/metal-amd64.iso"
}

module "proxmox_talos_worker_1" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "worker-1"
  node_name      = "mercury"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  memory_mb      = 10240
  cores          = 5
  bridge         = "vmbr0"
  iso_download_url = "https://factory.talos.dev/image/914b38adefad3d77212f565745ed52013bf3a424e7da2730e9e7dad8ee297342/v1.12.4/metal-amd64.iso"
}

module "proxmox_talos_worker_2" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "worker-2"
  node_name      = "neptune"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  memory_mb      = 6144
  cores          = 7
  bridge         = "vmbr0"
  iso_download_url = "https://factory.talos.dev/image/914b38adefad3d77212f565745ed52013bf3a424e7da2730e9e7dad8ee297342/v1.12.4/metal-amd64.iso"
}

module "proxmox_talos_worker_3" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "worker-3"
  node_name      = "pluto"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  memory_mb      = 6144
  cores          = 5
  bridge         = "vmbr0"
  iso_download_url = "https://factory.talos.dev/image/914b38adefad3d77212f565745ed52013bf3a424e7da2730e9e7dad8ee297342/v1.12.4/metal-amd64.iso"
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
  endpoints            = [for k, v in var.node_data.controlplanes : k]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  for_each                    = var.node_data.controlplanes
  node                        = each.key
  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = each.value.hostname == null ? format("%s-cp-%s", var.cluster_name, index(keys(var.node_data.controlplanes), each.key)) : each.value.hostname
      install_disk = each.value.install_disk
    }),
    file("${path.module}/files/cp-scheduling.yaml"),
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  for_each                    = var.node_data.workers
  node                        = each.key
  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = each.value.hostname == null ? format("%s-worker-%s", var.cluster_name, index(keys(var.node_data.workers), each.key)) : each.value.hostname
      install_disk = each.value.install_disk
    })
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.node_data.controlplanes : k][0]
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.node_data.controlplanes : k][0]
}
