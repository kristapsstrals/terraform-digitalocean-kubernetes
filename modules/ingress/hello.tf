resource "kubernetes_namespace" "hello" {
  # depends_on = [kubernetes_manifest.cluster_issuer]
  depends_on = [kubectl_manifest.cluster_issuer]

  metadata {
    name = "hello"
  }
}

resource "kubernetes_deployment" "hello" {
  depends_on = [kubernetes_namespace.hello]
  metadata {
    name      = "hello-kubernetes"
    namespace = "hello"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "hello-kubernetes"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-kubernetes"
        }
      }

      spec {
        container {
          image = "paulbouwer/hello-kubernetes:1.7"
          name  = "hello-kubernetes"

          port {
            container_port = 8080
          }

          env {
            name  = "MESSAGE"
            value = "Hello from the deployment!"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello" {
  depends_on = [kubernetes_namespace.hello]
  metadata {
    name      = "hello-kubernetes"
    namespace = "hello"
  }
  spec {
    selector = {
      app = "hello-kubernetes"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress" "hello_kubernetes" {
  depends_on = [kubernetes_namespace.hello]
  metadata {
    name      = "hello-kubernetes"
    namespace = "hello"

    annotations = {
      "cert-manager.io/cluster-issuer"             = "letsencrypt-prod"
      "kubernetes.io/ingress.class"                = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    tls {
      hosts       = ["hello.kriss.tech"]
      secret_name = "hello-kubernetes-tls"
    }

    rule {
      host = "hello.kriss.tech"

      http {
        path {
          path = "/"

          backend {
            service_name = "hello-kubernetes"
            service_port = "80"
          }
        }
      }
    }
  }
}
