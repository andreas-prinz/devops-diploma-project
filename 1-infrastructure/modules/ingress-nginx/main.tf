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
      value = "ClusterIP"
    },
    # ЦЕЙ ПАРАМЕТР САМ ПРИВ'ЯЖЕ NGINX ДО ПОРТІВ 80/443 САМОЇ Linux-МАШИНИ
    {
      name  = "controller.hostNetwork"
      value = "true"
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
