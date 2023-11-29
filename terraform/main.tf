terraform {
  required_version = ">= 1.1"
}

module "tutorial" {
  source = "github.com/LKummer/terraform-proxmox//modules/machine?ref=2.0.1"

  proxmox_api_url     = var.proxmox_api_url
  proxmox_target_node = var.proxmox_target_node
  proxmox_template    = "alpine-3.18.4-1"

  name                   = "tutorial-machine"
  description            = "Created from tutorial example."
  on_boot                = true
  memory                 = 1024 * 6
  cores                  = 4
  disk_pool              = "local-lvm"
  disk_size              = "10G"
  cloud_init_public_keys = var.cloud_init_public_keys
}
