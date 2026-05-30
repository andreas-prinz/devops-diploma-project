# 1-infrastructure/prod/network/terragrunt.hcl

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

terraform {
  source = "tfr:///terraform-google-modules/network/google//.?version=10.0.0"
}

dependency "api" {
  config_path = "../services"
}

inputs = {
  project_id   = local.project_id
  network_name = "diploma-vpc"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name   = "gke-subnet"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = local.region

      subnet_private_access = "true"
    }
  ]

  secondary_ranges = {
    "gke-subnet" = [
      {
        range_name    = "gke-pods-range"
        ip_cidr_range = "10.48.0.0/14" # Великий діапазон для ваших подів
      },
      {
        range_name    = "gke-services-range"
        ip_cidr_range = "10.52.0.0/20" # Діапазон для сервісів (ClusterIP)
      }
    ]
  }

  # Додаємо правило фаєрволу для SSH
  firewall_rules = [
    {
      name      = "allow-nginx-ingress"
      direction = "INGRESS"
      priority  = 1000
      ranges    = ["0.0.0.0/0"] # В ідеалі впиши сюди свій IP (напр. "1.2.3.4/32")
      allow = [{
        protocol = "tcp"
        ports    = ["80","443"]
      }]
    }
  ]
}
