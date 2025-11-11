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
  source        = "./modules/amplify_app"
  github_token  = var.github_token
  repo_url      = var.repo_url
  repo_branch   = var.repo_branch
  frontend_dir  = var.frontend_dir
}

