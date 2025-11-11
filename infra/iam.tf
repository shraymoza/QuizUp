#########################
# IAM Roles and Policies
#########################

# Lambda Trust Policy
data "aws_iam_policy_document" "lambda_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

# Lambda Policy
data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.quizup.arn}/*"]
  }

  statement {
    actions   = ["sagemaker:InvokeEndpoint"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.project_name}-lambda-policy"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# SageMaker Trust Policy
data "aws_iam_policy_document" "sm_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

# SageMaker Execution Role
resource "aws_iam_role" "sagemaker_role" {
  name               = "${var.project_name}-sagemaker-role"
  assume_role_policy = data.aws_iam_policy_document.sm_trust.json
}

# SageMaker Policy
data "aws_iam_policy_document" "sagemaker_policy" {
  statement {
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.quizup.arn,
      "${aws_s3_bucket.quizup.arn}/*"
    ]
  }

  statement {
    actions   = ["logs:*", "ecr:GetAuthorizationToken", "ecr:BatchGetImage", "ecr:GetDownloadUrlForLayer"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "sagemaker_policy" {
  name   = "${var.project_name}-sagemaker-policy"
  policy = data.aws_iam_policy_document.sagemaker_policy.json
}

resource "aws_iam_role_policy_attachment" "sagemaker_attach" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = aws_iam_policy.sagemaker_policy.arn
}
