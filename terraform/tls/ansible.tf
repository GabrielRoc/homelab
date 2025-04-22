resource "tls_private_key" "ansible_host_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}