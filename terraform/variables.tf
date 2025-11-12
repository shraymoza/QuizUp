variable "environment" {
  description = "Deployment environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Named AWS CLI profile to use for credentials"
  type        = string
  default     = "default"
}

variable "project_name" {
  description = "Short name used for tagging and resource naming"
  type        = string
  default     = "quizup"
}
