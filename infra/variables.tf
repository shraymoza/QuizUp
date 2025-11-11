variable "project_name" {
  type    = string
  default = "quizup"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  type = string
}

variable "sm_endpoint_name" {
  type    = string
  default = "quizup-sm-endpoint"
}

variable "amplify_repository_url" {
  type        = string
  description = "Git repository URL for Amplify (e.g., https://github.com/username/quizup.git)"
  default     = ""
}

variable "github_oauth_token" {
  type        = string
  description = "GitHub OAuth token for Amplify (optional, only if using GitHub)"
  default     = ""
  sensitive   = true
}

variable "custom_domain" {
  type        = string
  description = "Custom domain for Amplify app (optional)"
  default     = ""
}