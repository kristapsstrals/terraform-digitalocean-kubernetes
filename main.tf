module "do_cluster" {
  source = "./modules/cluster"

  providers = {
    digitalocean = digitalocean
  }

  do_token     = var.do_token
  cluster_name = var.cluster_name
}

module "ingress_controller" {
  source = "./modules/ingress"

  depends_on = [module.do_cluster]

  providers = {
    helm       = helm
    kubernetes = kubernetes
    kubectl    = kubectl
    # kubernetes-alpha = kubernetes-alpha
  }
}

module "drone_ci" {
  source = "./modules/droneci"

  depends_on = [module.ingress_controller]

  providers = {
    helm       = helm
    kubernetes = kubernetes
    kubectl    = kubectl
    # kubernetes-alpha = kubernetes-alpha
  }
}
