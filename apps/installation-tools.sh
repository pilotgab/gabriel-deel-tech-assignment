#!/bin/bash
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace

kubectl apply -n ingress-nginx -f html-site-ingress.yaml
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl apply -n argocd -f ../argocd-applications/deel-test-application.yaml


helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create ns monitoring
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -f prom-values.yaml -n monitoring

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install promtail grafana/promtail -f promtail-values.yaml -n monitoring

helm upgrade --install loki grafana/loki-distributed -n monitoring


