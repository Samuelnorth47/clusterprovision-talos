output "talosconfig" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}

output "control_plane_ips" {
  value = {
    for k, v in module.talos_cp_nodes : k => v.vm_ipv4_addresses[0]
  }
}

output "worker_ips" {
  value = {
    for k, v in module.talos_worker_nodes : k => v.vm_ipv4_addresses[0]
  }
}
