data "digitalocean_kubernetes_versions" "kubernetes_versions" {}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name   = var.cluster_name
  region  = var.cluster_region
  version = data.digitalocean_kubernetes_versions.kubernetes_versions.latest_version
  tags    = var.cluster_tags

  auto_upgrade = true

  node_pool {
    name       = "worker-pool"
    size       = var.cluster_node_size
    node_count = var.cluster_node_count

    auto_scale = true
    min_nodes = var.cluster_min_nodes
    max_nodes = var.cluster_max_nodes
  }
}
