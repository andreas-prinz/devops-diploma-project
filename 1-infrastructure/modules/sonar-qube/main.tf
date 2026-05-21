# 1-infrastructure/modules/sonar-qube/main.tf

# Обов'язково вказуємо Terraform, що нам потрібен саме Helm провайдер
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

resource "helm_release" "sonarqube" {
  name             = "sonarqube"
  repository       = "https://sonarsource.github.io/helm-chart-sonarqube"
  chart            = "sonarqube"
  version          = "2026.3.0"
  namespace        = "sonarqube"
  create_namespace = true

  timeout          = 900
  
  set = [
    {
      name  = "postgresql.enabled"
      value = "false"
    },
    {
      name  = "sonarProperties.sonar.embeddedDatabase.port"
      value = "9092"
    },
    {
      name  = "resources.requests.cpu"
      value = "200m"
    },
    {
      name  = "resources.requests.memory"
      value = "1024Mi"
    },
    {
      name  = "monitoringPasscode"
      value = var.passcode
    },
    {
      name  = "community.enabled"
      value = "true"
    },
  ]
}

