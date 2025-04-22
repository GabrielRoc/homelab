output "ubuntu_template" {
  description = "The ID of the Ubuntu template."
  value       = proxmox_virtual_environment_vm.ubuntu_template.id
}