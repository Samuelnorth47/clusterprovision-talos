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

variable "proxmox_node" {
  description = "Proxmox API host (shortname or FQDN). If empty, falls back to env PROXMOX_NODE."
  type        = string
  default     = ""
}

variable "proxmox_api_user" {
  description = "Proxmox API user part of the token (e.g. 'root@pam'). Falls back to PROXMOX_API_USER."
  type        = string
  default     = ""
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID. Falls back to PROXMOX_API_TOKEN_ID."
  type        = string
  default     = ""
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret. Falls back to PROXMOX_API_TOKEN_SECRET."
  type        = string
  default     = ""
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Whether to skip TLS verification when talking to Proxmox."
  type        = bool
  default     = true
}

variable "proxmox_ssh_agent" {
  description = "Whether to use local ssh-agent for provider ssh actions."
  type        = bool
  default     = true
}

variable "proxmox_ssh_username" {
  description = "SSH username to use for provider SSH operations (if any)."
  type        = string
  default     = "root"
}
