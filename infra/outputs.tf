# S3 website outputs removed - using Amplify for hosting now

output "hosted_ui_login_url" {
  value       = length(aws_amplify_app.quizup) > 0 ? "https://${aws_cognito_user_pool_domain.domain.domain}.auth.${var.region}.amazoncognito.com/login?client_id=${aws_cognito_user_pool_client.client.id}&response_type=token&scope=openid+email+profile&redirect_uri=${urlencode("https://${aws_amplify_branch.main[0].branch_name}.${aws_amplify_app.quizup[0].default_domain}")}" : "Not configured - set amplify_repository_url variable"
  description = "Cognito Hosted UI Login / Signup URL (using Amplify domain)"
}

output "hosted_ui_logout_url" {
  value       = length(aws_amplify_app.quizup) > 0 ? "https://${aws_cognito_user_pool_domain.domain.domain}.auth.${var.region}.amazoncognito.com/logout?client_id=${aws_cognito_user_pool_client.client.id}&logout_uri=${urlencode("https://${aws_amplify_branch.main[0].branch_name}.${aws_amplify_app.quizup[0].default_domain}")}" : "Not configured - set amplify_repository_url variable"
  description = "Cognito Hosted UI Logout URL (using Amplify domain)"
}

output "api_base_url" {
  value       = aws_api_gateway_deployment.dep.invoke_url
  description = "Base URL for API Gateway"
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.pool.id
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "sagemaker_notebook_name" {
  value = aws_sagemaker_notebook_instance.nb.name
}

output "amplify_app_id" {
  value       = length(aws_amplify_app.quizup) > 0 ? aws_amplify_app.quizup[0].id : "Not configured - set amplify_repository_url variable"
  description = "AWS Amplify App ID"
}

output "amplify_app_default_domain" {
  value       = length(aws_amplify_app.quizup) > 0 ? aws_amplify_app.quizup[0].default_domain : "Not configured - set amplify_repository_url variable"
  description = "Default domain for the Amplify app"
}

output "amplify_branch_url" {
  value       = length(aws_amplify_branch.main) > 0 ? "https://${aws_amplify_branch.main[0].branch_name}.${aws_amplify_app.quizup[0].default_domain}" : "Not configured - set amplify_repository_url variable"
  description = "URL for the main branch deployment"
}