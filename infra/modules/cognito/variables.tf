variable "project_name" {
  description = "Project name for naming resources"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "amplify_domain" {
  description = "Amplify domain for callback URLs"
  type        = string
}

variable "callback_urls" {
  description = "List of callback URLs for Cognito user pool client"
  type        = list(string)
}

variable "logout_urls" {
  description = "List of logout URLs for Cognito user pool client"
  type        = list(string)
}
