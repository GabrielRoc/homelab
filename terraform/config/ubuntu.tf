resource "proxmox_virtual_environment_file" "ubuntu_user_data_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = <<-EOF
    #cloud-config
    users:
      - default
      - name: gabriel
        ssh-authorized-keys:
            - ${trimspace(file(var.ssh_public_key_path))}
            - ${trimspace(var.ansible_host_key)}
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: sudo
        shell: /bin/bash
    packages_update: true
    packages:
      - qemu-guest-agent
      - net-tools
      - curl
      - pipx
      - git
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - pipx ensurepath && sudo pipx ensurepath --global
      - pipx install --include-deps ansible
      - curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up --auth-key=${var.tailscale_auth_key}
      - echo "done" > /tmp/cloud-config.done

    EOF

    file_name = "ubuntu.cloud-config.yaml"
  }
}