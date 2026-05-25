# 1-infrastructure/modules/nexus/main.tf

# Обов'язково вказуємо Terraform, що нам потрібен саме Helm провайдер
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

resource "helm_release" "nexus" {
  name             = "nexus"
  repository       = "https://sonatype.github.io/helm3-charts/"
  chart            = "nexus-repository-manager"
  version          = "92.2.0"
  namespace        = "nexus"
  create_namespace = true

  
  # Nexus написаний на Java, тому йому треба чітко обмежити пам'ять, 
  # щоб він не "з'їв" усі ресурси ноди в GKE
  set = [
    {
      name  = "nexus.env[0].name"
      value = "INSTALL4J_ADD_VM_PARAMS"
    },
    {
      name  = "nexus.env[0].value"
      value = "-Xms1024m -Xmx1024m -XX:MaxDirectMemorySize=1024m"
    },
    # Вимикаємо Ingress для простоти, порт можна буде прокинути через kubectl port-forward
    {
      name  = "ingress.enabled"
      value = "false"
    },
  ]
}
