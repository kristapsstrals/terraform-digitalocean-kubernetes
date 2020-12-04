resource "kubernetes_ingress" "echo_ingress" {
  metadata {
    name = "echo-ingress"
    namespace = var.namespace

    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
    }
  }

  spec {
    tls {
      hosts = [ "echo1.krisstech.com", "echo2.krisstech.com" ]
      secret_name = "echo-tls"
    }

    rule {
      host = "echo1.krisstech.com"
      http {
        path {
          backend {
            service_name = kubernetes_service.echo.metadata.0.name
            service_port = 80
          }
        }
      }
    }
    rule {
      host = "echo2.krisstech.com"
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