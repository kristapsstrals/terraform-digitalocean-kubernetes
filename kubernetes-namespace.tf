resource "kubernetes_namespace" "krisstech" {
  metadata {
    name = var.namespace
  }
}