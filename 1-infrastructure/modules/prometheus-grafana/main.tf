# 1-infrastructure/modules/prometheus-grafana/main.tf

# Обов'язково вказуємо Terraform, що нам потрібен саме Helm провайдер
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

# 1. Prometheus + Grafana (Kube-Prometheus-Stack)
resource "helm_release" "prometheus_stack" {
  name             = "prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "85.2.2"
  namespace        = "monitoring"
  create_namespace = true

  set = [
    {
      name  = "grafana.enabled"
      value = "true"
    },
    {
      name  = "prometheus.prometheusSpec.resources.requests.memory"
      value = "1Gi"
    }
  ]
}
