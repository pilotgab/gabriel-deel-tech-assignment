
provider "helm" {
  kubernetes {
    config_context = "my-kube-context"
  }
}

resource "helm_release" "argocd" {
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  name       = "deel-test-argocd"
  version    = "3.20.0"

  values = [
    file("values.yaml"),
  ]
}

