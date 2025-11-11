#######################################################
# Amazon Cognito – User Pool, Client, and Hosted Domain
#######################################################

# Random ID to make the domain unique in the region
resource "random_id" "domain_suffix" {
  byte_length = 4
}

# Cognito User Pool
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

# Cognito User Pool App Client (for the website)
resource "aws_cognito_user_pool_client" "client" {
  name         = "${var.project_name}-web"
  user_pool_id = aws_cognito_user_pool.pool.id

  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers         = ["COGNITO"]

  # Callback URLs - use localhost for local development (HTTPS not required for localhost)
  # Amplify URLs (HTTPS) will be added automatically after Amplify is created
  # This avoids a circular dependency during initial creation
  # The null_resource in cognito_amplify_update.tf will update these after Amplify exists
  callback_urls = [
    "http://localhost:3000",
    "http://localhost:5173",  # Vite default port
    "http://localhost:8080"
  ]
  logout_urls = [
    "http://localhost:3000",
    "http://localhost:5173",
    "http://localhost:8080"
  ]



  generate_secret = false
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

# Hosted UI domain (unique per region)
resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "${var.project_name}-${random_id.domain_suffix.hex}"
  user_pool_id = aws_cognito_user_pool.pool.id
}
