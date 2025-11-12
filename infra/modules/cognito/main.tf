resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_cognito_user_pool" "users" {
  name = "${var.project_name}-cognito-${random_id.suffix.hex}-user-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  mfa_configuration        = "OFF"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "${var.project_name}-web-client"
  user_pool_id = aws_cognito_user_pool.users.id
  generate_secret = false

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows   = ["implicit"]
  allowed_oauth_scopes  = ["email", "openid", "profile"]
  supported_identity_providers = ["COGNITO"]

  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls

  # Ignore changes to URLs to allow null_resource to update them
  lifecycle {
    ignore_changes = [callback_urls, logout_urls]
  }
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "${var.project_name}-${random_id.suffix.hex}"
  user_pool_id = aws_cognito_user_pool.users.id
}
