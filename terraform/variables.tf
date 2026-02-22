#Proxmox
variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    name           = string
    node_name      = string
    memory_mb      = number
    cores          = number
    disk_datastore = string
    disk_size_gb   = number
    bridge         = string
    iso_download_url = string
  }))

  default = {
    "talos-node-0" = {
      name           = "talos-node-0"
      node_name      = "mercury"
      memory_mb      = 2048
      cores          = 2
      disk_datastore = "local-lvm"
      disk_size_gb   = 20
      bridge         = "vmbr0"
      iso_download_url = "https://factory.talos.dev/image/914b38adefad3d77212f565745ed52013bf3a424e7da2730e9e7dad8ee297342/v1.12.4/metal-amd64.iso"
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

# Talos
variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
}

variable "node_data" {
  description = "A map of node data"
  type = object({
    controlplanes = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
    workers = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
  })
  default = {
    controlplanes = {
      "10.5.0.2" = {
        install_disk = "/dev/sda"
      },
      "10.5.0.3" = {
        install_disk = "/dev/sda"
      },
      "10.5.0.4" = {
        install_disk = "/dev/sda"
      }
    }
    workers = {
      "10.5.0.5" = {
        install_disk = "/dev/nvme0n1"
        hostname     = "worker-1"
      },
      "10.5.0.6" = {
        install_disk = "/dev/nvme0n1"
        hostname     = "worker-2"
      }
    }
  }
}
