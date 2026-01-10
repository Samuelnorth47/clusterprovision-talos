
terraform {
  backend "local" {
    path = "/opt/actions-runner/terraform/terraform.tfstate"
  }
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.75.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://${var.proxmox_node}:8006/"
  api_token = "${var.proxmox_api_user}!${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure  = true

  ssh {
    agent    = true
    username = "root"
  }

}

module "proxmox_talos_master_1" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "master-1"
  node_name      = "venus"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  iso_storage    = "local"
  memory_mb      = 13312
  cores          = 7
  iso_file       = "metal-amd64-qemu-agent.iso"
  bridge         = "vmbr0"
}

module "proxmox_talos_master_2" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "master-2"
  node_name      = "saturn"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  iso_storage    = "local"
  memory_mb      = 13312
  cores          = 11
  iso_file       = "metal-amd64-qemu-agent.iso"
  bridge         = "vmbr0"
}

module "proxmox_talos_master_3" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "master-3"
  node_name      = "mercury"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  iso_storage    = "local"
  memory_mb      = 10240
  cores          = 6
  iso_file       = "metal-amd64-qemu-agent.iso"
  bridge         = "vmbr0"
}

module "proxmox_talos_worker_1" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "worker-1"
  node_name      = "mercury"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  iso_storage    = "local"
  memory_mb      = 10240
  cores          = 5
  iso_file       = "metal-amd64-qemu-agent.iso"
  bridge         = "vmbr0"
}

module "proxmox_talos_worker_2" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "worker-2"
  node_name      = "neptune"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  iso_storage    = "local"
  memory_mb      = 6144
  cores          = 7
  iso_file       = "metal-amd64-qemu-agent.iso"
  bridge         = "vmbr0"
}

module "proxmox_talos_worker_3" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "worker-3"
  node_name      = "pluto"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  iso_storage    = "local"
  memory_mb      = 6144
  cores          = 5
  iso_file       = "metal-amd64-qemu-agent.iso"
  bridge         = "vmbr0"
}

