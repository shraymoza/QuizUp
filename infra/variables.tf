variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Amplify app name"
  type        = string
  default     = "quizup-web"
}

variable "branch_name" {
  description = "Git branch"
  type        = string
  default     = "main"
}

variable "github_repo" {
  description = "GitHub repository URL"
  type        = string
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "cognito_user_pool_id" {
  description = "Optional Cognito User Pool ID"
  type        = string
  default     = ""
}

variable "cognito_client_id" {
  description = "Optional Cognito App Client ID"
  type        = string
  default     = ""
}
variable "project_name" {
  description = "Project name"
  type        = string
  default     = "quizup"
}

variable "assume_role_arn" {
  description = "ARN of IAM role to assume (e.g., LabRole for Learner Lab). Leave empty to use default credentials."
  type        = string
  default     = ""
}
