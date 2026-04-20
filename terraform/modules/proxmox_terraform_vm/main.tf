terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.75.0"
    }
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
    floating  = var.memory_mb
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
    file_id = proxmox_virtual_environment_download_file.talos_iso.id
  }

  network_device {
    bridge = var.bridge
    model  = "virtio"
  }
}

resource "proxmox_virtual_environment_download_file" "talos_iso" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.node_name
  url          = var.iso_download_url
}
