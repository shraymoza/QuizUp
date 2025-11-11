terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


module "cognito" {
  source       = "./modules/cognito"
  project_name = "quizup"
  region       = var.aws_region
  # Start with localhost only; after first Amplify build you can re-apply with the Amplify URL included
  callback_urls = [
    "http://localhost:3000",
    "http://localhost:5173",
    "http://localhost:8080"
  ]
  logout_urls = [
    "http://localhost:3000",
    "http://localhost:5173",
    "http://localhost:8080"
  ]
}

module "amplify_app" {
  source = "./modules/amplify_app"

  aws_region           = var.aws_region
  app_name             = var.app_name
  branch_name          = var.branch_name
  github_repo          = var.github_repo
  github_token         = var.github_token
  cognito_user_pool_id = module.cognito.user_pool_id
  cognito_client_id    = module.cognito.client_id
}

