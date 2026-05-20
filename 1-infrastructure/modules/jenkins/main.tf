# 1-infrastructure/modules/jenkins/main.tf

# Обов'язково вказуємо Terraform, що нам потрібен саме Helm провайдер
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = "5.9.22"
  namespace        = "jenkins"
  create_namespace = true

  set = [
    {
      name  = "controller.installPlugins[0]"
      value = "kubernetes:latest"
    },
    {
      name  = "controller.installPlugins[1]"
      value = "workflow-aggregator:latest"
    },
    {
      name  = "controller.installPlugins[2]"
      value = "git:latest"
    },
    {
      name  = "controller.resources.requests.cpu"
      value = "500m"
    },
    {
      name  = "controller.enableRawHtmlSidebar"
      value = "false"
    }
  ]
}
