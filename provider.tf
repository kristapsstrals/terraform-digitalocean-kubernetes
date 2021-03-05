provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_kubernetes_cluster" "do_cluster_name" {
  depends_on = [module.do_cluster]
  name       = var.cluster_name
}

provider "kubernetes" {
  host  = data.digitalocean_kubernetes_cluster.do_cluster_name.endpoint
  token = data.digitalocean_kubernetes_cluster.do_cluster_name.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.do_cluster_name.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = data.digitalocean_kubernetes_cluster.do_cluster_name.endpoint
    token = data.digitalocean_kubernetes_cluster.do_cluster_name.kube_config[0].token
    cluster_ca_certificate = base64decode(
      data.digitalocean_kubernetes_cluster.do_cluster_name.kube_config[0].cluster_ca_certificate
    )
  }
}

provider "kubectl" {
  load_config_file = false
  host             = data.digitalocean_kubernetes_cluster.do_cluster_name.endpoint
  token            = data.digitalocean_kubernetes_cluster.do_cluster_name.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.do_cluster_name.kube_config[0].cluster_ca_certificate
  )
}

# TODO - if kubernetes-alpha works, it will replace the kubectl provider
# provider "kubernetes-alpha" {
#   host  = data.digitalocean_kubernetes_cluster.do_cluster_name.endpoint
#   token = data.digitalocean_kubernetes_cluster.do_cluster_name.kube_config[0].token
#   cluster_ca_certificate = base64decode(
#     data.digitalocean_kubernetes_cluster.do_cluster_name.kube_config[0].cluster_ca_certificate
#   )
# }
