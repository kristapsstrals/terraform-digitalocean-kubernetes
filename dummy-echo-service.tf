resource "kubernetes_service" "echo" {
  metadata {
    name = "echo1"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.echo.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 5678
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "echo" {
  metadata {
    name = "echo1"
    namespace = var.namespace
    labels = {
      app = "echo1"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "echo1"
      }
    }

    template {
      metadata {
        labels = {
          app = "echo1"
        }
      }

      spec {
        container {
          image = "hashicorp/http-echo"
          name  = "echo1"

          args = [ "-text=echo1" ]


          port {
            container_port = 5678
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "echo2" {
  metadata {
    name = "echo2"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.echo2.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 5678
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "echo2" {
  metadata {
    name = "echo2"
    namespace = var.namespace
    labels = {
      app = "echo2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "echo2"
      }
    }

    template {
      metadata {
        labels = {
          app = "echo2"
        }
      }

      spec {
        container {
          image = "hashicorp/http-echo"
          name  = "echo2"

          args = [ "-text=echo2" ]


          port {
            container_port = 5678
          }
        }
      }
    }
  }
}