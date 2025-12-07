# modules/proxmox_full_vm/variables.tf
variable "name"        { type = string }
variable "node_name"   { type = string }
variable "memory_mb"   { type = number }
variable "cores"       { type = number }
variable "disk_datastore" { type = string }
variable "disk_size"   { type = string }      
variable "iso_storage" { type = string }      
variable "iso_file"    { type = string }     
variable "bridge"      { type = string }      
