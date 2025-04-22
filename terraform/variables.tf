variable "virtual_environment_endpoint" {
  description = "The endpoint for the virtual environment"
  type        = string
}

variable "virtual_environment_api_token" {
  description = "The API token for the virtual environment"
  type        = string
}

variable "ssh_username" {
  description = "The SSH username for the virtual environment"
  type        = string
}

variable "ssh_private_key_path" {
  description = "The SSH private key for the virtual environment"
  type        = string
}

variable "ssh_public_key_path" {
  description = "The SSH public key for the virtual environment"
  type        = string
}

variable "tailscale_auth_key" {
  description = "The Tailscale auth key for the machine"
  type        = string
}

variable "git_repo_url" {
  description = "The URL of the Git repository."
  type        = string
}