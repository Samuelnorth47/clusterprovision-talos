# variables.tf at root

variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    name         = string  # VM name
    node_name    = string  # Proxmox host node
    memory_mb    = number
    cores        = number
    disk_datastore = string
    disk_size_gb = number
    iso_storage  = string  
    iso_filename = string  
    bridge       = string
  }))
  
  default = {
    "talos-node-0" = {
      name            = "talos-node-0"
      node_name       = "mercury"
      memory_mb       = 2048
      cores           = 2
      disk_datastore  = "local-lvm"
      disk_size_gb    = 20
      iso_storage     = "local"
      iso_filename    = "metal-amd64.iso"
      bridge          = "vmbr0"
    }
  }
}
