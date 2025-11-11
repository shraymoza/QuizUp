output "user_pool_id" {
  value = aws_cognito_user_pool.pool.id
}

output "client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "domain" {
  value = aws_cognito_user_pool_domain.domain.domain
}

output "hosted_ui_login_url" {
  value = "https://${aws_cognito_user_pool_domain.domain.domain}.auth.${var.region}.amazoncognito.com/login?client_id=${aws_cognito_user_pool_client.client.id}&response_type=token&scope=openid+email+profile&redirect_uri=${urlencode(var.callback_urls[0])}"
}

output "hosted_ui_logout_url" {
  value = "https://${aws_cognito_user_pool_domain.domain.domain}.auth.${var.region}.amazoncognito.com/logout?client_id=${aws_cognito_user_pool_client.client.id}&logout_uri=${urlencode(var.logout_urls[0])}"
}


