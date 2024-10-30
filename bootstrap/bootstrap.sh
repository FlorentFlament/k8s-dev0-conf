# Create a kind cluster (or use a K8s cluster anywhere)
kind create cluster

# Install basic argocd - no custom variables
helm install argocd bitnami/argo-cd -n argocd --create-namespace

# Expose argocd via port forwarding (Or do that with k9s)
kubectl -n argocd port-forward svc/argocd-argo-cd-server 8443:443 &

# Allow argocd to connect to private git repo
argocd login localhost:8443 \
       --username admin \
       --password $(kubectl -n argocd get secret argocd-secret -o json | jq -r .data.clearPassword | base64 -d) \
       --insecure

# Plug argoCD to our configuration repo
kubectl apply -f apps.yaml
