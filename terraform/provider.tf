provider "proxmox" {
  endpoint  = var.virtual_environment_endpoint
  api_token = var.virtual_environment_api_token
  insecure  = true
  ssh {
    agent       = false
    username    = var.ssh_username
    private_key = file(var.ssh_private_key_path)
  }
}