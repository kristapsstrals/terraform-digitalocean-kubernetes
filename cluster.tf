data "digitalocean_kubernetes_versions" "kubernetes_versions" {}

resource "digitalocean_kubernetes_cluster" "krisstech" {
  name   = "krisstech"
  region  = "fra1"
  version = data.digitalocean_kubernetes_versions.kubernetes_versions.latest_version
  tags    = ["dev"]

  auto_upgrade = true

  node_pool {
    name       = "worker-pool"
    size       = "s-1vcpu-2gb"
    node_count = 1

    auto_scale = true
    min_nodes = 1
    max_nodes = 3
  }
}
