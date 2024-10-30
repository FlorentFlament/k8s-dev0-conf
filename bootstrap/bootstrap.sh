#!/bin/sh
set -eux

kind create cluster --config kind.yaml

helm install argocd bitnami/argo-cd -n argocd --create-namespace

kubectl wait --namespace argocd \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=server \
  --timeout=300s

kubectl apply -f apps.yaml
