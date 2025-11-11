# AWS Amplify Deployment Guide

This guide explains how to deploy your Quiz Up React application to AWS Amplify using Terraform.

## Prerequisites

1. Your code is pushed to a Git repository (GitHub, GitLab, Bitbucket, or AWS CodeCommit)
2. Terraform is configured and you have AWS credentials set up
3. Your Cognito User Pool is already created

## Step 1: Get Your Repository URL

Get the URL of your Git repository. Examples:
- GitHub: `https://github.com/username/quizup.git`
- GitLab: `https://gitlab.com/username/quizup.git`
- Bitbucket: `https://bitbucket.org/username/quizup.git`
- CodeCommit: `https://git-codecommit.us-east-1.amazonaws.com/v1/repos/quizup`

## Step 2: Configure Terraform Variables

Edit `terraform.tfvars` and add your repository URL:

```hcl
bucket_name      = "quizup-shray-123456"
region           = "us-east-1"
sm_endpoint_name = "quizup-sm-endpoint"

# Add this line with your repository URL
amplify_repository_url = "https://github.com/yourusername/quizup.git"
```

### Optional: GitHub OAuth Token

If using GitHub, you may need to provide an OAuth token. You can:
1. Generate a personal access token from GitHub Settings > Developer settings > Personal access tokens
2. Add it to `terraform.tfvars`:
   ```hcl
   github_oauth_token = "ghp_your_token_here"
   ```

**Note:** The `terraform.tfvars` file is in `.gitignore` and won't be committed to your repository.

## Step 3: Deploy Amplify Infrastructure

Run Terraform to create the Amplify app:

```bash
cd infra
terraform init
terraform plan
terraform apply
```

This will create:
- IAM role for Amplify
- Amplify app connected to your repository
- Main branch configuration
- Environment variables (Cognito User Pool ID, Client ID, Region)

## Step 4: Connect Repository (First Time Only)

After Terraform creates the Amplify app, you need to connect your repository:

1. Go to AWS Amplify Console: https://console.aws.amazon.com/amplify
2. Find your app (named `quizup-web`)
3. Click on it and go to "App settings" > "General"
4. Under "Repository", click "Connect branch"
5. Follow the prompts to authorize access to your Git provider
6. Select your branch (usually `main` or `master`)

## Step 5: Update Cognito Callback URLs

After Amplify deploys, you'll get a URL. You need to update Cognito to allow this URL:

1. Get your Amplify URL from Terraform outputs:
   ```bash
   terraform output amplify_branch_url
   ```

2. Update `infra/cognito.tf` to include the Amplify URL in callback URLs:
   ```hcl
   callback_urls = [
     "http://${aws_s3_bucket_website_configuration.site_www.website_endpoint}",
     "https://main.${aws_amplify_app.quizup[0].default_domain}",
     "https://${aws_amplify_branch.main[0].branch_name}.${aws_amplify_app.quizup[0].default_domain}"
   ]
   logout_urls = [
     "http://${aws_s3_bucket_website_configuration.site_www.website_endpoint}",
     "https://main.${aws_amplify_app.quizup[0].default_domain}",
     "https://${aws_amplify_branch.main[0].branch_name}.${aws_amplify_app.quizup[0].default_domain}"
   ]
   ```

3. Apply the changes:
   ```bash
   terraform apply
   ```

## Step 6: Verify Deployment

1. Check Terraform outputs for your Amplify URL:
   ```bash
   terraform output amplify_branch_url
   ```

2. Visit the URL in your browser
3. Test sign up and sign in functionality

## Troubleshooting

### Build Fails

- Check the Amplify console for build logs
- Ensure `package.json` is in the `web/` directory
- Verify build commands in `amplify.tf` match your project structure

### Authentication Not Working

- Verify Cognito callback URLs include your Amplify domain
- Check environment variables in Amplify console match Terraform outputs
- Ensure Cognito User Pool allows the Amplify domain

### Repository Connection Issues

- Verify your repository URL is correct
- For GitHub, ensure you've authorized AWS Amplify
- Check that your branch name matches (usually `main` or `master`)

## Environment Variables

The following environment variables are automatically set in Amplify:
- `VITE_COGNITO_USER_POOL_ID` - From your Cognito User Pool
- `VITE_COGNITO_CLIENT_ID` - From your Cognito App Client
- `VITE_AWS_REGION` - Your AWS region (us-east-1)

These are configured automatically by Terraform, so you don't need to set them manually in the Amplify console.

## Custom Domain (Optional)

To add a custom domain:

1. Add to `terraform.tfvars`:
   ```hcl
   custom_domain = "quizup.example.com"
   ```

2. Uncomment the domain association in `amplify.tf`

3. Run `terraform apply`

4. Configure DNS records as shown in Terraform outputs

## Cleanup

To remove Amplify resources:

```bash
terraform destroy
```

Or remove just Amplify:

1. Remove `amplify_repository_url` from `terraform.tfvars`
2. Run `terraform apply` (resources with `count = 0` will be removed)

