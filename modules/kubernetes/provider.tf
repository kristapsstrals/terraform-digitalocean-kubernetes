terraform {
  required_providers {
    # digitalocean = {
    #   source  = "digitalocean/digitalocean"
    #   version = "~> 2.2.0"
    # }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 1.13.3"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.9.4"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 2.0.0"
    }
  }
}

# # Configure the DigitalOcean Provider
# provider "digitalocean" {
#   token = var.do_token
# }

# data "digitalocean_kubernetes_cluster" "do_cluster" {
#   name = "krisstech"
# }

# provider "kubernetes" {
#   load_config_file = false
#   host             = data.digitalocean_kubernetes_cluster.do_cluster.endpoint
#   token            = data.digitalocean_kubernetes_cluster.do_cluster.kube_config[0].token
#   cluster_ca_certificate = base64decode(
#     data.digitalocean_kubernetes_cluster.do_cluster.kube_config[0].cluster_ca_certificate
#   )
# }
