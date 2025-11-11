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

# Block public ACLs/policies except for the website endpoint
resource "aws_s3_bucket_public_access_block" "quizup_block" {
  bucket                  = aws_s3_bucket.quizup.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Allow public read only for website objects
data "aws_iam_policy_document" "public_read" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.quizup.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.quizup.id
  policy = data.aws_iam_policy_document.public_read.json
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "site_www" {
  bucket = aws_s3_bucket.quizup.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Optional: create logical folders for organization
locals {
  prefixes = ["raw/", "indexes/", "outputs/"]
}

resource "aws_s3_object" "prefixes" {
  for_each = toset(local.prefixes)
  bucket   = aws_s3_bucket.quizup.id
  key      = each.key
}
