provider "digitalocean" {
  token = var.do_token
}

module "do_cluster" {
  source = "./modules/cluster"

  providers = {
    digitalocean = digitalocean
  }

  do_token = var.do_token
  cluster_name = var.cluster_name
}

data "digitalocean_kubernetes_cluster" "do_cluster_name" {
  depends_on = [ module.do_cluster ]
  name = var.cluster_name
}

provider "kubernetes" {
  load_config_file = false
  host             = data.digitalocean_kubernetes_cluster.do_cluster_name.endpoint
  token            = data.digitalocean_kubernetes_cluster.do_cluster_name.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.do_cluster_name.kube_config[0].cluster_ca_certificate
  )
}

provider "http" { }
provider "kubectl" {
  load_config_file = false
  host             = data.digitalocean_kubernetes_cluster.do_cluster_name.endpoint
  token            = data.digitalocean_kubernetes_cluster.do_cluster_name.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.do_cluster_name.kube_config[0].cluster_ca_certificate
  )
}


module "kubernetes_cluster_base" {
  source = "./modules/kubernetes"

  depends_on = [module.do_cluster]

  providers = {
    kubernetes = kubernetes
    kubectl    = kubectl
    http       = http
  }

  do_token = var.do_token
}
