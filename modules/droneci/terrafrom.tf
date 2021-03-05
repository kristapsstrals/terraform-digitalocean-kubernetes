terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 2.1.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.2"
    }
    # kubernetes-alpha = {
    #   source  = "hashicorp/kubernetes-alpha"
    #   version = "0.2.0"
    # }
  }
}
