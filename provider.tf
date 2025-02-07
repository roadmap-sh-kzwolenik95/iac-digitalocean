terraform {
  cloud {
    organization = "roadmap-sh"
    hostname     = "app.terraform.io"

    workspaces {
      name = "iac-digitalocean"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {}

data "digitalocean_ssh_key" "terraform" {
  name = var.ssh_key_name
}