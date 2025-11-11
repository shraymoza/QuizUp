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
            - cd frontend
            - npm install --include=dev
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
  YAML

  environment_variables = {
    NODE_ENV = "development"
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
    interpreter = ["PowerShell", "-Command"]
    command     = <<EOT
      $status = aws amplify list-jobs --app-id ${aws_amplify_app.web.id} --branch-name ${aws_amplify_branch.main.branch_name} --query "jobSummaries[0].status" --output text
      if ($status -eq "PENDING" -or $status -eq "RUNNING") {
        Write-Host "A build is already in progress, skipping trigger."
      } else {
        aws amplify start-job --app-id ${aws_amplify_app.web.id} --branch-name ${aws_amplify_branch.main.branch_name} --job-type RELEASE | Out-Null
        Write-Host "Triggered a new Amplify build."
      }
    EOT
  }

  # only trigger when frontend actually changes
  triggers = {
    build = filesha1("${path.root}/../frontend/package.json")
  }
}







output "amplify_url" {
  value = "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.web.default_domain}"
}
