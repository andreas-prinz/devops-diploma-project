# 1-infrastructure/prod/services/terragrunt.hcl

locals {
  root_config = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  project_id  = local.root_config.locals.project_id
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "tfr:///terraform-google-modules/project-factory/google//modules/project_services?version=18.2.0"
}

inputs = {
  project_id = local.project_id

  # Сервіси, які нам критично потрібні для проєкту:
  activate_apis = [
    "compute.googleapis.com",    # Мережа та Віртуальні машини
    "container.googleapis.com",  # Kubernetes (GKE)
    "iam.googleapis.com",        # Керування доступами
  ]
  
  disable_services_on_destroy = false
}
