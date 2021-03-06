terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.5.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.2"
    }
    # kubernetes-alpha = {
    #   source = "hashicorp/kubernetes-alpha"
    #   version = "0.2.0"
    # }
  }
}
