module "files" {
  source = "./files"
  providers = {
    proxmox = proxmox
    tls     = tls
  }
}

module "tls" {
  source = "./tls"
  providers = {
    proxmox = proxmox
    tls     = tls
  }
}

module "config" {
  source = "./config"
  providers = {
    proxmox = proxmox
    tls     = tls
  }

  tailscale_auth_key  = var.tailscale_auth_key
  ansible_host_key    = module.tls.ansible_host_key
  ssh_public_key_path = var.ssh_public_key_path
}

module "templates" {
  source = "./templates"
  providers = {
    proxmox = proxmox
    tls     = tls
  }

  depends_on = [
    module.files,
    module.config
  ]

  ubuntu_cloud_image      = module.files.ubuntu_cloud_image
  ubuntu_user_data_config = module.config.ubuntu_user_data_config
}

module "machines" {
  source = "./machines"
  providers = {
    proxmox = proxmox
    tls     = tls
  }

  depends_on = [
    module.templates,
  ]

  ubuntu_template          = module.templates.ubuntu_template
  ssh_private_key_path     = var.ssh_private_key_path
  ansible_host_private_key = module.tls.ansible_host_private_key
}