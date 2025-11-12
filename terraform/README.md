# Terraform Setup

This directory holds Terraform configuration for QuizUp infrastructure.

## Prerequisites

- Terraform 1.6 or newer: https://developer.hashicorp.com/terraform/install
- AWS CLI v2: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- An AWS account with permissions to manage IAM, S3, Lambda, API Gateway, SageMaker, Cognito and CloudWatch resources.

## Configure AWS Credentials

### Option 1: Access Keys (programmatic user)
1. In the AWS console, open **IAM → Users → Add users** and create a user with `Programmatic access`.
2. Attach an appropriate permission policy (start with `AdministratorAccess` while bootstrapping; restrict later).
3. Download the Access Key ID and Secret Access Key.
4. In PowerShell, run `aws configure` and enter the keys, your default region (e.g., `us-east-1`), and output format (`json`).
5. Confirm credentials with `aws sts get-caller-identity`.

### Option 2: AWS IAM Identity Center (SSO)
1. Configure IAM Identity Center in your AWS account if not already set up.
2. Run `aws configure sso` and follow the prompts to authenticate in the browser.
3. Define the default SSO profile name (e.g., `sso-quizup`).
4. Export the profile before running Terraform: `setx AWS_PROFILE sso-quizup` (PowerShell) or use `terraform` CLI flag `-var aws_profile=sso-quizup`.
5. Run `aws sts get-caller-identity` to verify the authenticated identity.

## Initialize Terraform

```powershell
cd terraform
# copy the example vars and fill in real values
Copy-Item terraform.tfvars.example terraform.tfvars
# (if using remote state) copy backend example and update names
Copy-Item backend.tf.example backend.tf
# initialize Terraform
terraform init
terraform validate
```

Use `terraform plan` and `terraform apply` to manage infrastructure. For multiple environments, Terraform workspaces (`terraform workspace new dev`) or per-environment directories are recommended.

## Credentials Hygiene

- Never commit `terraform.tfvars`, `backend.tf`, or credentials files.
- Rotate access keys periodically.
- Prefer least-privilege policies once the infrastructure layout stabilizes.
