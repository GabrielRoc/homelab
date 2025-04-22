terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.76.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "rochatecnogia"
    key    = "tfstates/pve/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-pve-lock"

    encrypt = true
  }
}