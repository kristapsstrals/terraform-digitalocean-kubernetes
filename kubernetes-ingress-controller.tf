# Ingres controller provided by nignx
# https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes
# https://kubernetes.github.io/ingress-nginx/deploy/#digital-ocean
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/do/deploy.yaml

# !IMPORTANT - DigitalOcean LoadBalancer fix for HTTPS certs (from tutorial)
# Step 5 from https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes
# Add DNS A record for workaround.<domain> to load balancer IP (workaround.example.com)
# Add annotation to the ingress-nginx-controller service:
# service.beta.kubernetes.io/do-loadbalancer-hostname: "workaround.example.com"
