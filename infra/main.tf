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
  source        = "./modules/cognito"
  project_name  = "quizup"
  region        = var.region
  amplify_domain = "${aws_amplify_app.web.default_domain}"
  callback_url   = "https://main.${aws_amplify_app.web.default_domain}"
  logout_url     = "https://main.${aws_amplify_app.web.default_domain}"
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

resource "local_file" "frontend_env" {
  content = <<EOT
VITE_AWS_REGION=${var.region}
VITE_USER_POOL_ID=${module.cognito.cognito_user_pool_id}
VITE_CLIENT_ID=${module.cognito.cognito_client_id}
VITE_COGNITO_DOMAIN=${module.cognito.cognito_domain}
VITE_REDIRECT_URI=https://main.${module.amplify_app.amplify_app_default_domain}
EOT
  filename = "${path.root}/../frontend/.env.production"
}


