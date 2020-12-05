resource "kubernetes_ingress" "echo_ingress" {
  depends_on = [ kubectl_manifest.nginx_ingress_controller, kubectl_manifest.cluster_issuer_prod ]

  metadata {
    name = "echo-ingress"
    namespace = var.namespace

    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
    }
  }

  spec {
    tls {
      hosts = [ "echo1.${var.ingress_hostname}", "echo2.${var.ingress_hostname}" ]
      secret_name = "echo-tls"
    }

    rule {
      host = "echo1.${var.ingress_hostname}m"
      http {
        path {
          backend {
            service_name = kubernetes_service.echo1.metadata.0.name
            service_port = 80
          }
        }
      }
    }
    rule {
      host = "echo2.${var.ingress_hostname}"
      http {
        path {
          backend {
            service_name = kubernetes_service.echo2.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}