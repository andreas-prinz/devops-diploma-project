# 1-infrastructure/modules/gitlab/main.tf

# Обов'язково вказуємо Terraform, що нам потрібен саме Helm провайдер
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

resource "helm_release" "gitlab" {
  name             = "gitlab"
  repository       = "https://charts.gitlab.io/"
  chart            = "nexus-repository-manager"
  version          = "10.0.0"
  namespace        = "gitlab"
  create_namespace = true
  timeout          = 600 # GitLab важкий і встановлюється довго, тому збільшуємо таймаут

  
  # Базові налаштування для безкоштовної версії (CE) та спрощення
  set = [
    {
      name  = "global.edition"
      value = "ce"
    },
    # Автоматичне вимкнення вбудованого Cert-Manager (якщо у вас є свій)
    {
      name  = "certmanager.install"
      value = "false"
    },
    # Вимикаємо cert-manager для простоти, якщо не будемо купувати реальний домен
    {
      name  = "global.ingress.configureCertmanager"
      value = "false"
    },
    # Доменне ім'я для локального GitLab (можна буде прописати в /etc/hosts)
    {
      name  = "global.hosts.domain"
      value = "gitlab.local"
    },
    # Зменшення лімітів пам'яті для мінімального старту (для економії ресурсів у GKE)
    {
      name  = "gitlab.webservice.resources.requests.memory"
      value = "2Gi"
    },
    {
      name  = "gitlab.sidekiq.resources.requests.memory"
      value = "1Gi"
    },
  ]
}
