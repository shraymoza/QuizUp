###############################################
# AWS Amplify App for Quiz Up Web Application
###############################################

# IAM Role for Amplify to access resources
resource "aws_iam_role" "amplify_role" {
  count = var.amplify_repository_url != "" ? 1 : 0
  name  = "${var.project_name}-amplify-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "amplify.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Amplify to deploy and manage the app
resource "aws_iam_role_policy" "amplify_policy" {
  count = var.amplify_repository_url != "" ? 1 : 0
  name  = "${var.project_name}-amplify-policy"
  role  = aws_iam_role.amplify_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "amplify:*",
          "amplifybackend:*",
          "cloudformation:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "codecommit:GitPull",
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ]
        Resource = "*"
      }
    ]
  })
}

# Local value to check if repository is GitHub
locals {
  is_github_repo = var.amplify_repository_url != "" && can(regex("^https://github\\.com", var.amplify_repository_url))
  # Check if token exists and is not empty (trim whitespace)
  github_token_trimmed = var.github_oauth_token != null ? trimspace(var.github_oauth_token) : ""
  has_github_token = local.github_token_trimmed != ""
}

# AWS Amplify App
resource "aws_amplify_app" "quizup" {
  count      = var.amplify_repository_url != "" ? 1 : 0
  name       = "${var.project_name}-web"
  repository = var.amplify_repository_url

  # OAuth token is required for GitHub repositories
  # Only set oauth_token if it's a GitHub repo AND token is provided (not empty)
  # If using GitHub and token is missing, AWS will return error: "You should at least provide one valid token"
  # See GITHUB_TOKEN_SETUP.md for instructions on creating and adding the token
  oauth_token = local.is_github_repo && local.has_github_token ? local.github_token_trimmed : null

  # Build specification
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - cd web
            - npm install
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: web/dist
        files:
          - '**/*'
      cache:
        paths:
          - web/node_modules/**/*
  EOT

  # Environment variables for the build
  environment_variables = {
    VITE_COGNITO_USER_POOL_ID = aws_cognito_user_pool.pool.id
    VITE_COGNITO_CLIENT_ID    = aws_cognito_user_pool_client.client.id
    VITE_AWS_REGION           = var.region
  }

  # Enable auto branch creation
  enable_auto_branch_creation = true
  enable_branch_auto_build    = true
  enable_branch_auto_deletion = true

  # IAM service role
  iam_service_role_arn = aws_iam_role.amplify_role[0].arn

  # Custom rules for SPA routing
  custom_rule {
    source = "/<*>"
    status = "200"
    target = "/index.html"
  }

  tags = {
    Project = var.project_name
    Environment = "production"
  }
}

# Amplify Branch for main/master
resource "aws_amplify_branch" "main" {
  count      = var.amplify_repository_url != "" ? 1 : 0
  app_id      = aws_amplify_app.quizup[0].id
  branch_name = "main"

  # Enable auto build
  enable_auto_build = true

  # Environment variables specific to this branch
  environment_variables = {
    NODE_ENV = "production"
  }

  # Framework (optional, helps with routing)
  framework = "React"

  # Stage
  stage = "PRODUCTION"
}

# Amplify Domain (optional - for custom domain)
# Uncomment and configure if you want to set up a custom domain
# resource "aws_amplify_domain_association" "main" {
#   app_id      = aws_amplify_app.quizup.id
#   domain_name = var.custom_domain
#
#   sub_domain {
#     branch_name = aws_amplify_branch.main.branch_name
#     prefix      = ""
#   }
#
#   sub_domain {
#     branch_name = aws_amplify_branch.main.branch_name
#     prefix      = "www"
#   }
# }

