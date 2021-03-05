resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress"

  repository = "https://charts.helm.sh/stable"
  chart      = "nginx-ingress"

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }
}

# Should use ingress controller from here, but SSL was not working for some reason
# resource "helm_release" "nginx_ingress" {
#   name = "nginx-ingress"
#   namespace        = "nginx-ingress"
#   create_namespace = true

#   repository = "https://helm.nginx.com/stable"
#   chart      = "nginx-ingress"

#   set {
#     name  = "controller.publishService.enabled"
#     value = "true"
#   }
# }

resource "helm_release" "cert_manager" {
  depends_on       = [helm_release.nginx_ingress]
  name             = "cert-manager"
  namespace        = "cert-manager"
  version          = "v1.2.0"
  create_namespace = true

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubectl_manifest" "cluster_issuer" {
  depends_on = [helm_release.cert_manager]
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    # Email address used for ACME registration
    email: kristaps@kriss.tech
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Name of a secret used to store the ACME account private key
      name: letsencrypt-prod-private-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx
YAML
}

# resource "kubernetes_manifest" "cluster_issuer" {
#   provider = kubernetes-alpha

#   manifest = {
#     apiVersion = "cert-manager.io/v1"
#     kind       = "ClusterIssuer"
#     metadata = {
#       name      = "letsencrypt-prod"
#       namespace = "cert-manager"
#     }
#     spec = {
#       acme = {
#         email  = "kristaps@kriss.tech"
#         server = "https://acme-v02.api.letsencrypt.org/directory"
#         privateKeySecretRef = {
#           name = "letsencrypt-prod-private-key"
#         }
#         solvers = [
#           {
#             http01 = {
#               ingress = {
#                 class = "nginx"
#               }
#             }
#           }
#         ]
#       }
#     }
#   }
# }
