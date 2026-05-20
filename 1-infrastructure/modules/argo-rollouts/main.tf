# 1-infrastructure/modules/argo-rollouts/main.tf

# Обов'язково вказуємо Terraform, що нам потрібен саме Helm провайдер
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

# Argo Rollouts (для твого Canary)
resource "helm_release" "argo_rollouts" {
  name             = "argo-rollouts"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-rollouts"
  version          = "2.40.9"
  namespace        = "argo-rollouts"
  create_namespace = true

  set = [
    {
      name  = "dashboard.enabled"
      value = "true"
    }
  ]
}
