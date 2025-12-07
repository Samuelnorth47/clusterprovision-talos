module "proxmox_talos_master_1" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "master-1"
  node_name      = "mercury"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  iso_storage    = "local"
  memory_mb      = 2048
  cores          = 2
  iso_file       = "metal-amd64-qemu-agent.iso"
  bridge         = "vmbr0"
}

module "proxmox_talos_master_2" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "master-2"
  node_name      = "mercury"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  iso_storage    = "local"
  memory_mb      = 2048
  cores          = 2
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
  memory_mb      = 2048
  cores          = 2
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
  memory_mb      = 2048
  cores          = 2
  iso_file       = "metal-amd64-qemu-agent.iso"
  bridge         = "vmbr0"
}

module "proxmox_talos_worker_2" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "worker-2"
  node_name      = "mercury"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  iso_storage    = "local"
  memory_mb      = 2048
  cores          = 2
  iso_file       = "metal-amd64-qemu-agent.iso"
  bridge         = "vmbr0"
}

module "proxmox_talos_worker_3" {
  source         = "./modules/proxmox_terraform_vm"
  name           = "worker-3"
  node_name      = "mercury"
  disk_datastore = "local-lvm"
  disk_size      = "20"
  iso_storage    = "local"
  memory_mb      = 2048
  cores          = 2
  iso_file       = "metal-amd64-qemu-agent.iso"
  bridge         = "vmbr0"
}

