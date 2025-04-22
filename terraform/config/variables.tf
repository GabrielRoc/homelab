variable "tailscale_auth_key" {
  description = "The Tailscale auth key for the machine."
  type        = string
}

variable "ansible_host_key" {
  description = "The Ansible host key."
  type        = string
}

variable "ssh_public_key_path" {
  description = "The path to the SSH public key for the machine."
  type        = string
}