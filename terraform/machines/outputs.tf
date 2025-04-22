output "ansible_ipv4_address" {
  description = "The IPv4 address of the ansible VM."
  value       = proxmox_virtual_environment_vm.ansible.ipv4_addresses[1][0]
}