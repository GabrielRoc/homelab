variable "ubuntu_template" {
  description = "The ID of the Ubuntu template."
  type        = string
}

variable "ansible_host_private_key" {
  description = "The Ansible host private key."
  type        = string
}

variable "ssh_private_key_path" {
  description = "The path to the SSH private key for the machine."
  type        = string
}

variable "git_repo_url" {
  description = "The URL of the Git repository."
  type        = string
}