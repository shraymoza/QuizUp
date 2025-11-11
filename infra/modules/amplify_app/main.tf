resource "aws_amplify_app" "web" {
  name         = "quizup-web"
  repository   = var.github_repo
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
  branch_name = var.branch_name
  enable_auto_build = true
  framework         = "React"
  stage             = "PRODUCTION"
}
resource "aws_amplify_webhook" "main" {
  app_id      = aws_amplify_app.web.id
  branch_name = aws_amplify_branch.main.branch_name
  description = "Trigger Amplify build on Terraform apply"
}
resource "null_resource" "trigger_build" {
  provisioner "local-exec" {
    # Check build status first; only start if nothing is pending
    command = <<EOT
      for /f "tokens=*" %%i in ('aws amplify list-jobs --app-id ${aws_amplify_app.web.id} --branch-name ${aws_amplify_branch.main.branch_name} --query "jobSummaries[0].status" --output text') do set STATUS=%%i
      if /I "%STATUS%"=="PENDING" (
          echo "A job is already pending, skipping trigger."
      ) else (
          aws amplify start-job --app-id ${aws_amplify_app.web.id} --branch-name ${aws_amplify_branch.main.branch_name} --job-type RELEASE
      )
    EOT
    interpreter = ["cmd", "/C"]
  }

  # only re-run when code actually changes
  triggers = {
    build = filesha1("${path.root}/../frontend/package.json")
  }
}






output "amplify_url" {
  value = "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.web.default_domain}"
}
