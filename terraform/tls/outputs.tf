output "ansible_host_key" {
  description = "The Ansible host key."
  value       = tls_private_key.ansible_host_key.private_key_pem
}

output "ansible_host_private_key" {
  description = "The Ansible host private key."
  value       = tls_private_key.ansible_host_key.private_key_pem
}