resource "helm_release" "crone_server" {
  name             = "drone"
  namespace        = "drone"
  create_namespace = true

  repository = "https://charts.drone.io"
  chart      = "drone"

  values = [
    file("${path.module}/values.yaml"),
  ]
}

resource "helm_release" "drone_runner_kube" {
  depends_on       = [helm_release.crone_server]
  name             = "drone-runner-kube"
  namespace        = "drone"
  create_namespace = false

  repository = "https://charts.drone.io"
  chart      = "drone-runner-kube"

  values = [
    file("${path.module}/drone-runner-kube-values.yaml"),
  ]
}
