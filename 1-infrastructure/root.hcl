# 1-infrastructure/root.hcl

# 1. Автоматично визначаємо змінні або зчитуємо їх із системного середовища (Environment Variables)
locals {
  project_id  = get_env("TF_VAR_gcp_project_id", "your-default-project-id")
  region      = get_env("TF_VAR_gcp_region", "europe-west1")
  zone_suffix = get_env("ZONE_SUFFIX", "b")
  zone        = "${local.region}-${local.zone_suffix}"
  passcode    = get_env("TF_VAR_monitoring_passcode", "MySuperSecretPasscode999!")
}

# 2. Налаштування віддаленого зберігання стану (Remote State) в Google Cloud Storage (GCS)
remote_state {
  backend = "gcs"

  config = {
    project = local.project_id
    bucket  = "tf-state-${local.project_id}"
    prefix  = "${path_relative_to_include()}/terraform.tfstate"
    location = local.region
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# 3. Автоматична генерація файлу провайдера (provider.tf) для всіх дочірніх модулів
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = "${local.project_id}"
  region  = "${local.region}"
}
EOF
}

generate "shared_providers" {
  path      = "shared_providers.tf"
  if_exists = "overwrite_terragrunt"
  # Прибираємо генерацію файлу для мережі, gke та базових сервісів
  contents  = (length(regexall(".*/(network|gke|services)$", path_relative_to_include())) > 0) ? "" : <<EOF
variable "cluster_name" { type = string }
variable "project_id"   { type = string }
variable "location"     { type = string }

# Налаштування підключення до GKE
data "google_client_config" "default" {}
data "google_container_cluster" "my_cluster" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.location
}

provider "helm" {
  kubernetes = {
    host                   = "https://$${data.google_container_cluster.my_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
  }
}
EOF
}
