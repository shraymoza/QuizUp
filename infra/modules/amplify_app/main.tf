terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_amplify_app" "app" {
  name       = var.app_name
  repository = var.github_repo

  oauth_token = var.github_token

  build_spec = <<EOT
version: 1
frontend:
  phases:
    preBuild:
      commands:
        - cd frontend
        - npm ci || npm install
    build:
      commands:
        - npm run build
  artifacts:
    baseDirectory: frontend/dist
    files:
      - '**/*'
  cache:
    paths:
      - frontend/node_modules/**/*
EOT

  environment_variables = {
    VITE_COGNITO_USER_POOL_ID = var.cognito_user_pool_id
    VITE_COGNITO_CLIENT_ID    = var.cognito_client_id
    VITE_AWS_REGION           = var.aws_region
  }

  custom_rule {
    source = "/<*>"
    status = "200"
    target = "/index.html"
  }
}

resource "aws_amplify_branch" "main" {
  app_id            = aws_amplify_app.app.id
  branch_name       = var.branch_name
  enable_auto_build = true
  framework         = "React"
  stage             = "PRODUCTION"

  environment_variables = {
    NODE_ENV = "production"
  }
}


