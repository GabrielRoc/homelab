resource "proxmox_virtual_environment_vm" "ansible" {
  name      = "ansible"
  node_name = "pve"
  vm_id    = 101

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
    bridge = "vmbr0"
    mac_address = "BC:24:11:1F:87:01"
  }

  provisioner "file" {
    content     = var.ansible_host_private_key
    destination = "/home/gabriel/.ssh/ansible_node_key"

    connection {
      type        = "ssh"
      host = split("/", self.ipv4_addresses[0][0])[0]
      user        = "gabriel"
      private_key = file(pathexpand(var.ssh_private_key_path))
      agent       = false
    }
  }
}