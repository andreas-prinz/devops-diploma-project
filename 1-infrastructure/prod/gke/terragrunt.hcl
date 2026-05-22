# 1-infrastructure/prod/gke/terragrunt.hcl

locals {
  root_config = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  # Витягуємо змінні з прочитаного файлу  
  project_id  = local.root_config.locals.project_id
  region      = local.root_config.locals.region
  zone        = local.root_config.locals.zone
}

include "root" {
  # Явно вказуємо назву файлу, який треба знайти
  path = find_in_parent_folders("root.hcl") 
}

# Вказуємо Terragrunt спочатку створити мережу, а потім кластер
dependency "vpc" {
  config_path = "../network"
}

terraform {
  source = "tfr://registry.terraform.io/terraform-google-modules/kubernetes-engine/google?version=44.2.0"
}

inputs = {
  project_id = local.project_id
  name       = "diploma-prod-cluster"
  region     = local.region
  regional   = false
  zones      = ["${local.zone}"]

  deletion_protection = false

  # Використовуємо мережу, яку створив модуль network
  network    = dependency.vpc.outputs.network_name
  subnetwork = dependency.vpc.outputs.subnets_names[0]

  ip_range_pods      = "gke-pods-range"
  ip_range_services  = "gke-services-range"

  node_pools = [
    {
      name               = "go-app-node-pool"
      machine_type       = "e2-standard-2"
      node_locations     = local.zone
      autoscaling        = true
      min_count          = 1
      max_count          = 3
      # Стартова кількість нод при створенні
      initial_node_count = 1
      spot               = true
      disk_size_gb       = 30
      disk_type          = "pd-balanced"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = true
    },
  ]

  # Дозволяємо нодам мати публічні IP, щоб ти міг до них достукатись
  deploy_using_private_endpoint = false
  enable_private_nodes          = false
}
