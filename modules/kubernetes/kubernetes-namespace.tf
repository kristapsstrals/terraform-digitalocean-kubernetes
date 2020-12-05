resource "kubernetes_namespace" "cluster_namespace" {
  metadata {
    name = var.namespace
  }
}