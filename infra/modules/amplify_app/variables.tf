variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "app_name" {
  description = "Amplify app name"
  type        = string
}

variable "branch_name" {
  description = "Repository branch"
  type        = string
  default     = "main"
}

variable "github_repo" {
  description = "Git repository URL"
  type        = string
}

variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID (optional for now)"
  type        = string
  default     = ""
}

variable "cognito_client_id" {
  description = "Cognito App Client ID (optional for now)"
  type        = string
  default     = ""
}

variable "cognito_domain" {
  description = "Cognito domain for OAuth"
  type        = string
  default     = ""
}


