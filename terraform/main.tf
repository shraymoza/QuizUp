locals {
  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# TODO: Add module blocks for network, storage, auth, api, ml, and monitoring components.
# Example placeholder:
# module "storage" {
#   source       = "./modules/storage"
#   environment  = var.environment
#   project_name = var.project_name
#   tags         = local.tags
# }
