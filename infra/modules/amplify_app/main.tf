variable "github_token" { type = string }
variable "repo_url" { type = string }
variable "repo_branch" { type = string }
variable "frontend_dir" { type = string }

resource "aws_amplify_app" "web" {
  name         = "quizup-web"
  repository   = var.repo_url
  access_token = var.github_token

  build_spec = <<-YAML
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: dist
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  YAML

  environment_variables = {
    NODE_ENV = "production"
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.web.id
  branch_name = var.repo_branch
  enable_auto_build = true
  framework         = "React"
  stage             = "PRODUCTION"
}

output "amplify_url" {
  value = "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.web.default_domain}"
}
