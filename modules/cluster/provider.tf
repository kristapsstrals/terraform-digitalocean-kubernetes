terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.5.1"
    }
  }
}

# # Configure the DigitalOcean Provider
# provider "digitalocean" {
#   token = var.do_token
# }
