data "archive_file" "upload_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/upload"
  output_path = "${path.module}/../lambdas/upload.zip"
}
data "archive_file" "generate_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/generate"
  output_path = "${path.module}/../lambdas/generate.zip"
}

resource "aws_lambda_function" "upload" {
  function_name = "${var.project_name}-upload"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.10"
  handler       = "handler.handler"
  filename      = data.archive_file.upload_zip.output_path
  environment { variables = { BUCKET = aws_s3_bucket.quizup.bucket } }
}

resource "aws_lambda_function" "generate" {
  function_name = "${var.project_name}-generate"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.10"
  handler       = "handler.handler"
  filename      = data.archive_file.generate_zip.output_path
  timeout       = 60
  environment {
    variables = {
      BUCKET      = aws_s3_bucket.quizup.bucket
      SM_ENDPOINT = var.sm_endpoint_name
    }
  }
}
