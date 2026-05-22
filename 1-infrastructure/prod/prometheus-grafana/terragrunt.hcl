# 1-infrastructure/prod/prometheus-grafana/terragrunt.hcl

locals {
  root_config = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  # Витягуємо змінні з root.hcl
  project_id  = local.root_config.locals.project_id
  region      = local.root_config.locals.region
  zone        = local.root_config.locals.zone
}

include "root" {
  # Явно вказуємо назву файлу, який треба знайти
  path = find_in_parent_folders("root.hcl") 
}

dependency "gke" {
  config_path = "../gke"
}

# Використовуємо кастомний Terraform код для Helm релізів
terraform {
  source = "../../modules/prometheus-grafana"
}

inputs = {
  # Налаштування для підключення до твого кластера
  project_id   = local.project_id
  cluster_name = dependency.gke.outputs.name
  location     = local.zone
}
