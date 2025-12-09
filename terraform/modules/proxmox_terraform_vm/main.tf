
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.75.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://${env("PROXMOX_NODE")}:8006/"
  api_token = "${env("PROXMOX_API_USER")}!${env("PROXMOX_API_TOKEN_ID")}=${env("PROXMOX_API_TOKEN_SECRET")}"
  insecure = true

  ssh {
    agent = true
    username = "root"
  }

}
resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.name
  node_name = var.node_name
  
  agent {
    enabled = true
  }
 memory {
    dedicated = var.memory_mb
    floating = var.memory_mb
  }
  cpu { 
    cores = var.cores 
    type  = "host"  
  }

  disk {
    datastore_id = var.disk_datastore
    size         = var.disk_size
    interface    = "scsi0"
  }

  cdrom {
    file_id = "${var.iso_storage}:iso/${var.iso_file}"
  }

  network_device {
    bridge = var.bridge
    model  = "virtio"
  }
}

