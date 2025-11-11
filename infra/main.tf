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

  aws_region           = var.region
  app_name             = "${var.project_name}-web"
  branch_name          = var.branch_name
  github_repo          = var.amplify_repository_url
  github_token         = var.github_oauth_token
  # Cognito values can be plugged later when you add the module
  cognito_user_pool_id = ""
  cognito_client_id    = ""
}


