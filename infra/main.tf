terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


module "amplify_app" {
  source = "./modules/amplify_app"

  aws_region           = var.aws_region
  app_name             = var.app_name
  branch_name          = var.branch_name
  github_repo          = var.github_repo
  github_token         = var.github_token
  cognito_user_pool_id = var.cognito_user_pool_id
  cognito_client_id    = var.cognito_client_id
}

