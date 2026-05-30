# 1-infrastructure/modules/ingress-nginx/main.tf

# Обов'язково вказуємо Terraform, що нам потрібен саме Helm провайдер
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.15.1"
  namespace        = "ingress-nginx"
  create_namespace = true

  # Налаштування Helm-values без створення платних LoadBalancer у GCP
  set = [
    {
      name  = "controller.service.type"
      value = "NodePort"
    },
    {
      name  = "controller.service.nodePorts.http"
      value = "30080" # фіксований порт для HTTP (за бажанням)
    },
    {
      name  = "controller.service.nodePorts.https"
      value = "30443" # фіксований порт для HTTPS (за бажанням)
    },
    # Налаштування для коректної обробки Wildcard DNS від No-IP
    {
      name  = "controller.watchIngressWithoutClass"
      value = "true"
    },
    {
      name  = "controller.publishService.enabled"
      value = "false"
    }
  ]
}
