resource "aws_cloudwatch_log_group" "lambda_upload" {
  name              = "/aws/lambda/${aws_lambda_function.upload.function_name}"
  retention_in_days = 7
}
resource "aws_cloudwatch_log_group" "lambda_generate" {
  name              = "/aws/lambda/${aws_lambda_function.generate.function_name}"
  retention_in_days = 7
}

# Example alarm on Lambda errors
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.project_name}-lambda-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  dimensions          = { FunctionName = aws_lambda_function.generate.function_name }
}
