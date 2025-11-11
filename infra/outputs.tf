output "amplify_app_id" {
  value = module.amplify_app.amplify_app_id
}

output "amplify_app_default_domain" {
  value = module.amplify_app.amplify_app_default_domain
}

output "amplify_branch_url" {
  value = module.amplify_app.amplify_branch_url
}

output "cognito_user_pool_id" {
  value = module.cognito.user_pool_id
}

output "cognito_client_id" {
  value = module.cognito.client_id
}

output "cognito_hosted_ui_login_url" {
  value = module.cognito.hosted_ui_login_url
}

output "cognito_hosted_ui_logout_url" {
  value = module.cognito.hosted_ui_logout_url
}


