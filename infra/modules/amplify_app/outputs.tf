output "amplify_app_id" {
  value = aws_amplify_app.app.id
}

output "amplify_app_default_domain" {
  value = aws_amplify_app.app.default_domain
}

output "amplify_branch_url" {
  value = "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.app.default_domain}"
}


