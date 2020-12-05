# Ingres controller provided by nignx
# https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes
# https://kubernetes.github.io/ingress-nginx/deploy/#digital-ocean
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/do/deploy.yaml

# !IMPORTANT - DigitalOcean LoadBalancer fix for HTTPS certs (from tutorial)
# Step 5 from https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes
# Add DNS A record for workaround.<domain> to load balancer IP (workaround.example.com)
# Add annotation to the ingress-nginx-controller service:
# service.beta.kubernetes.io/do-loadbalancer-hostname: "workaround.example.com"

# kubectl -n ingress-nginx patch service ingress-nginx-controller --type='json' -p='[{"op": "add", "path": "/metadata/annotations/service.beta.kubernetes.io~1do-loadbalancer-hostname", "value": {"workaround.krisstech.com" } }]'

variable "nginx_version" {
  type = string
  default = "0.41.2"
}

data "http" "nginx_ingress_controller" {
  url = "https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v${var.nginx_version}/deploy/static/provider/do/deploy.yaml"
}

resource "kubectl_manifest" "nginx_ingress_controller" {
  yaml_body = data.http.nginx_ingress_controller.body
}

resource "kubectl_manifest" "nginx_ingress_controller_service" {
    depends_on = [ kubectl_manifest.nginx_ingress_controller ]

    yaml_body = <<YAML
# Source: ingress-nginx/templates/controller-service.yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    service.beta.kubernetes.io/do-loadbalancer-enable-proxy-protocol: 'true'
    service.beta.kubernetes.io/do-loadbalancer-hostname: "${var.do_workaround_hostname}"
  labels:
    helm.sh/chart: ingress-nginx-3.10.1
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.41.2
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: controller
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  type: LoadBalancer
  externalTrafficPolicy: Local
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: http
    - name: https
      port: 443
      protocol: TCP
      targetPort: https
  selector:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/component: controller
YAML
}
