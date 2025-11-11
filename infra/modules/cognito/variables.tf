variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "callback_urls" {
  description = "List of OAuth2 callback URLs (e.g., localhost + Amplify URL)"
  type        = list(string)
  default     = [
    "http://localhost:3000",
    "http://localhost:5173",
    "http://localhost:8080"
  ]
}

variable "logout_urls" {
  description = "List of logout redirect URLs"
  type        = list(string)
  default     = [
    "http://localhost:3000",
    "http://localhost:5173",
    "http://localhost:8080"
  ]
}


