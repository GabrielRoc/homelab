resource "proxmox_virtual_environment_vm" "ubuntu_template" {
  name      = "ubuntu-template"
  vm_id     = 10001
  node_name = "pve"

  template = true
  started  = false

  machine     = "q35"
  bios        = "ovmf"
  description = "Managed by Terraform"

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  efi_disk {
    datastore_id = "local-lvm"
    type         = "4m"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = var.ubuntu_cloud_image
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = var.ubuntu_user_data_config
  }

  network_device {
    bridge = "vmbr0"
  }

}