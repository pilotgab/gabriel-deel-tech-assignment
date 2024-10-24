#!/bin/bash
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  -f deploy.yaml


kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl apply -f ../argocd-app/*


helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

kubectl create ns monitoring

helm upgrade --install prom prometheus-community/kube-prometheus-stack -f ../monitoring/values.yaml -n monitoring

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

helm upgrade --install promtail grafana/promtail -f ../monitoring/promtail-values.yaml -n monitoring

helm upgrade --install loki grafana/loki-distributed -n monitoring


