# 1-infrastructure/modules/cert-manager/main.tf

# Обов'язково вказуємо Terraform, що нам потрібен саме Helm провайдер
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "1.20.2"
  namespace        = "cert-manager"
  create_namespace = true

  # Обов'язково встановлюємо CRD (CustomResourceDefinitions)
  set = [
    {
      name  = "installCRDs"
      value = "true"
    },
  ]
}
