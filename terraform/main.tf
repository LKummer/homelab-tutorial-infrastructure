terraform {
  required_version = ">= 1.1"
  backend "http" {}
}

module "tutorial" {
  source = "github.com/LKummer/terraform-proxmox//modules/machine?ref=4.0.0"

  proxmox_api_url  = var.proxmox_api_url
  proxmox_template = "alpine-3.18.5-2"

  name            = "tutorial-machine"
  description     = "Created from tutorial example."
  on_boot         = true
  memory          = 1024 * 6
  cores           = 4
  disk_pool       = "local-lvm"
  disk_size       = 10
  authorized_keys = setsubtract(concat(var.authorized_keys, [var.provisioning_authorized_key]), [""])
}
