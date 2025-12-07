# Proxmox provider is broken and VM IPs won't output
output "vm_names" {
  value = proxmox_virtual_environment_vm.vm.name
}

output "vm_ipv4_addresses" {
  value = flatten([proxmox_virtual_environment_vm.vm.ipv4_addresses])
}

output "vm_mac_addresses" {
  value = flatten(proxmox_virtual_environment_vm.vm.mac_addresses)
}