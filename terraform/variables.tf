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
  description = "Named AWS CLI profile to use for credentials (leave empty/null to use environment variables)"
  type        = string
  default     = null
}

variable "project_name" {
  description = "Short name used for tagging and resource naming"
  type        = string
  default     = "quizup"
}

variable "storage_raw_prefix" {
  description = "S3 key prefix for raw uploaded documents"
  type        = string
  default     = "raw/"
}

variable "storage_index_prefix" {
  description = "S3 key prefix for FAISS index artifacts"
  type        = string
  default     = "indexes/"
}

variable "storage_outputs_prefix" {
  description = "S3 key prefix for generated outputs (notes, quizzes)"
  type        = string
  default     = "outputs/"
}

variable "storage_enable_versioning" {
  description = "Enable versioning on primary storage bucket"
  type        = bool
  default     = true
}

variable "storage_force_destroy" {
  description = "Allow Terraform to delete non-empty S3 buckets (use with caution)"
  type        = bool
  default     = false
}

variable "network_vpc_cidr" {
  description = "CIDR block for the QuizUp VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "network_public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "network_private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "network_enable_nat_gateway" {
  description = "Enable managed NAT gateway for private subnet egress"
  type        = bool
  default     = true
}

variable "network_single_nat_gateway" {
  description = "Deploy a single NAT gateway instead of one per public subnet"
  type        = bool
  default     = true
}

variable "lambda_source_dir" {
  description = "Override path to the Lambda source directory (defaults to ../lambda/rag)."
  type        = string
  default     = ""
}

variable "lambda_package_path" {
  description = "Path to a pre-built Lambda deployment package. When set, source directory is ignored."
  type        = string
  default     = ""
}

variable "lambda_embedding_model" {
  description = "Sentence-transformers model used inside the Lambda for embeddings."
  type        = string
  default     = "sentence-transformers/all-MiniLM-L6-v2"
}

variable "lambda_rag_top_k" {
  description = "Number of context chunks to retrieve for the Lambda RAG prompt."
  type        = number
  default     = 5
}

variable "api_lambda_layers" {
  description = "List of Lambda Layer ARNs to attach to the RAG API function (for heavy dependencies like sentence-transformers)."
  type        = list(string)
  default     = []
}

variable "monitoring_alarm_topic_arn" {
  description = "SNS topic ARN for CloudWatch alarm notifications (optional)."
  type        = string
  default     = ""
}

variable "ml_model_artifact_s3_path" {
  description = "S3 path to custom SageMaker model artifact (tar.gz). If set, enables custom inference with embedding support."
  type        = string
  default     = ""
}

variable "ml_embedding_model_id" {
  description = "Hugging Face model ID for embeddings in custom inference script."
  type        = string
  default     = "sentence-transformers/all-MiniLM-L6-v2"
}
