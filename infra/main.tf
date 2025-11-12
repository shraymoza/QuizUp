terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}


# Initialize Cognito with localhost URLs only to break circular dependency
module "cognito" {
  source = "./modules/cognito"

  project_name   = var.project_name
  region         = var.aws_region
  amplify_domain = "" # Not used initially

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
  cognito_user_pool_id = module.cognito.cognito_user_pool_id
  cognito_client_id    = module.cognito.cognito_client_id
  cognito_domain       = module.cognito.cognito_domain
}

# Update Cognito callback URLs with Amplify URL after Amplify is deployed
resource "null_resource" "update_cognito_urls" {
  depends_on = [module.amplify_app]

  triggers = {
    amplify_domain = module.amplify_app.amplify_app_default_domain
    user_pool_id   = module.cognito.cognito_user_pool_id
    client_id      = module.cognito.cognito_client_id
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<EOT
      $amplifyUrl = "https://${var.branch_name}.${module.amplify_app.amplify_app_default_domain}"
      $userPoolId = "${module.cognito.cognito_user_pool_id}"
      $clientId = "${module.cognito.cognito_client_id}"
      
      $callbackUrls = @(
        $amplifyUrl,
        "http://localhost:3000",
        "http://localhost:5173",
        "http://localhost:8080"
      )
      $logoutUrls = @(
        $amplifyUrl,
        "http://localhost:3000",
        "http://localhost:5173",
        "http://localhost:8080"
      )
      
      $callbackArgs = $callbackUrls | ForEach-Object { "--callback-urls"; $_ }
      $logoutArgs = $logoutUrls | ForEach-Object { "--logout-urls"; $_ }
      
      aws cognito-idp update-user-pool-client `
        --user-pool-id $userPoolId `
        --client-id $clientId `
        $callbackArgs `
        $logoutArgs | Out-Null
      
      Write-Host "Updated Cognito callback URLs with Amplify URL: $amplifyUrl"
    EOT
  }
}

resource "local_file" "frontend_env" {
  depends_on = [module.amplify_app, module.cognito]
  
  content  = <<EOT
VITE_AWS_REGION=${var.aws_region}
VITE_USER_POOL_ID=${module.cognito.cognito_user_pool_id}
VITE_CLIENT_ID=${module.cognito.cognito_client_id}
VITE_COGNITO_DOMAIN=${module.cognito.cognito_domain}
VITE_REDIRECT_URI=https://${var.branch_name}.${module.amplify_app.amplify_app_default_domain}
EOT
  filename = "${path.root}/../frontend/.env.production"
}


