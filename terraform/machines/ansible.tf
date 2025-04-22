resource "proxmox_virtual_environment_vm" "ansible" {
  name      = "ansible"
  node_name = "pve"
  vm_id     = 101

  clone {
    vm_id = var.ubuntu_template
  }

  agent {
    enabled = true
  }

  memory {
    dedicated = 1024
  }

  initialization {
    dns {
      servers = ["1.1.1.1"]
    }
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge      = "vmbr0"
    mac_address = "BC:24:11:1F:87:01"
  }

  provisioner "remote-exec" {
    inline = ["echo 'SSH ready'"]
    connection {
      type        = "ssh"
      host        = split("/", self.ipv4_addresses[0][0])[0]
      user        = "gabriel"
      private_key = file(pathexpand(var.ssh_private_key_path))
      agent       = false
      timeout     = "10m"
    }
  }

  provisioner "file" {
    content     = var.ansible_host_private_key
    destination = "/home/gabriel/.ssh/ansible_node_key"

    connection {
      type        = "ssh"
      host        = split("/", self.ipv4_addresses[0][0])[0]
      user        = "gabriel"
      private_key = file(pathexpand(var.ssh_private_key_path))
      agent       = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/gabriel/.ssh/ansible_node_key",

      "HOMELAB_REPO_URL='${var.git_repo_url}'", # <<< OK - Interpolação Terraform
      "HOMELAB_DEST_DIR='/home/gabriel/homelab'",
      "ANSIBLE_RUN_SCRIPT_PATH='$${HOMELAB_DEST_DIR}/scripts/run_ansible_on_vm.sh'",

      "echo 'Cloning/Updating homelab repository...'",
      "mkdir -p $${HOMELAB_DEST_DIR}",

      "if [ ! -d $${HOMELAB_DEST_DIR}/.git ]; then git clone $${HOMELAB_REPO_URL} $${HOMELAB_DEST_DIR}; else echo 'Repo exists, skipping clone'; fi",

      "chown -R gabriel:gabriel $${HOMELAB_DEST_DIR} || true",
      "chmod +x $${ANSIBLE_RUN_SCRIPT_PATH}"
    ]

    connection {
      type        = "ssh"
      host        = split("/", self.ipv4_addresses[0][0])[0]
      user        = "gabriel"
      private_key = file(pathexpand(var.ssh_private_key_path))
      agent       = false
    }
  }


}