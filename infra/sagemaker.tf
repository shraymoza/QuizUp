resource "aws_sagemaker_notebook_instance" "nb" {
  name          = "${var.project_name}-nb"
  instance_type = "ml.t3.medium"
  role_arn      = aws_iam_role.sagemaker_role.arn
}