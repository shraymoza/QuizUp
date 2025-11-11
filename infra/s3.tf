###############################################
# S3 Bucket and Website Configuration
###############################################

# Create main project bucket
resource "aws_s3_bucket" "quizup" {
  bucket        = var.bucket_name
  force_destroy = true
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "quizup_sse" {
  bucket = aws_s3_bucket.quizup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access - bucket is now private (only used for Lambda storage)
resource "aws_s3_bucket_public_access_block" "quizup_block" {
  bucket                  = aws_s3_bucket.quizup.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets  = true
}

# Note: Public read policy and website configuration removed
# The bucket is now private and only used for Lambda function storage

# Optional: create logical folders for organization
locals {
  prefixes = ["raw/", "indexes/", "outputs/"]
}

resource "aws_s3_object" "prefixes" {
  for_each = toset(local.prefixes)
  bucket   = aws_s3_bucket.quizup.id
  key      = each.key
}
