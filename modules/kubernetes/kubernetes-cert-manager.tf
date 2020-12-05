# https://github.com/jetstack/cert-manager/releases
# kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml

data "http" "cert_manager_data" {
  url = "https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml"
}

resource "kubectl_manifest" "cert_manager" {
  yaml_body = data.http.cert_manager_data.body
}

# Cluster Issuer
resource "kubectl_manifest" "cluster_issuer" {
  depends_on = [ kubectl_manifest.cert_manager ]
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
 name: letsencrypt-staging
 namespace: cert-manager
spec:
 acme:
   # The ACME server URL
   server: https://acme-staging-v02.api.letsencrypt.org/directory
   # Email address used for ACME registration
   email: ${var.cert_manager_email}
   # Name of a secret used to store the ACME account private key
   privateKeySecretRef:
     name: letsencrypt-staging
   # Enable the HTTP-01 challenge provider
   solvers:
   - http01:
       ingress:
         class:  nginx
YAML
}

resource "kubectl_manifest" "cluster_issuer_prod" {
  depends_on = [ kubectl_manifest.cert_manager ]
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: ${var.cert_manager_email}
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class: nginx
YAML
}