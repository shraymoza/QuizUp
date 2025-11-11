variable "project_name" {
  type    = string
  default = "quizup"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "amplify_repository_url" {
  type        = string
  description = "Git repository URL for Amplify (e.g., https://github.com/user/repo.git)"
}

variable "github_oauth_token" {
  type        = string
  description = "GitHub OAuth token"
  sensitive   = true
}

variable "branch_name" {
  type        = string
  description = "Git branch to build"
  default     = "main"
}


