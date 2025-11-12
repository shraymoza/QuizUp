terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_cognito_user_pool" "pool" {
  name                     = "${var.project_name}-users"
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "${var.project_name}-client"
  user_pool_id = aws_cognito_user_pool.users.id
  generate_secret = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = ["implicit"]
  allowed_oauth_scopes = ["openid", "email", "profile"]
  supported_identity_providers = ["COGNITO"]

  callback_urls = [
    "http://localhost:3000",
    "https://${var.amplify_domain}",      # ADD THIS
  ]
  logout_urls = [
    "http://localhost:3000",
    "https://${var.amplify_domain}",      # ADD THIS
  ]
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "${var.project_name}-${random_id.suffix.hex}"
  user_pool_id = aws_cognito_user_pool.pool.id
}


