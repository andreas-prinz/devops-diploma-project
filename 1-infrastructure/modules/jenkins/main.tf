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
    },
#     {
#       name  = "controller.installPlugins"
#       value = "docker-commons:latest"
#     },
#     {
#       name  = "controller.installPlugins"
#       value = "docker-workflow:latest"
#     },
#     {
#       name  = "controller.installPlugins"
#       value = "docker-api:latest"
#     },
#     {
#       name  = "controller.installPlugins"
#       value = "docker-plugin:latest"
#     },
#     {
#       name  = "controller.installPlugins"
#       value = "docker-build-step:latest"
#     },
#     {
#       name  = "controller.installPlugins"
#       value = "docker-build-publish:latest"
#     },
    {
      name  = "controller.installPlugins"
      value = "ws-cleanup:latest"
    },
    {
      name  = "controller.installPlugins"
      value = "golang:latest"
    },
    {
      name  = "agent.enabled"
      value = "true"
    },
    {
      name  = "controller.JCasC.configScripts.go-tools"
      value = <<EOF
tool:
  go:
    installations:
      - name: "go-1.26.3"
        properties:
          - installSource:
              installers:
                - golang:
                    version: "1.26.3"
EOF
    },
    {
      name  = "controller.installPlugins[3]"
      value = "pipeline-stage-view:latest"
    },
    {
      name  = "controller.installPlugins[4]"
      value = "dependency-check-jenkins-plugin:latest"
    },
        {
      name  = "controller.JCasC.enabled"
      value = "true"
    },
    {
      name  = "controller.JCasC.configScripts.owasp-tool-config"
      value = "tool:\n  dependencyCheck:\n    installations:\n      - name: \"OWASP-Default\"\n        properties:\n          - installSource:\n              installers:\n                - dependencyCheckInstaller:\n                    id: \"latest\""
    },
  ]
}
