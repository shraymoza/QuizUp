# GitHub OAuth Token Setup for Amplify

## Why You Need This

When connecting a GitHub repository to AWS Amplify via Terraform, you need to provide a GitHub OAuth token for authentication.

## How to Create a GitHub Personal Access Token

1. **Go to GitHub Settings**
   - Visit: https://github.com/settings/tokens
   - Or: GitHub Profile → Settings → Developer settings → Personal access tokens → Tokens (classic)

2. **Generate New Token**
   - Click "Generate new token" → "Generate new token (classic)"
   - Give it a name: `AWS Amplify QuizUp`
   - Select expiration (recommended: 90 days or custom)
   - Select scopes:
     - ✅ `repo` (Full control of private repositories) - if your repo is private
     - ✅ `public_repo` (Access public repositories) - if your repo is public
     - ✅ `admin:repo_hook` (Full control of repository hooks) - recommended

3. **Generate and Copy Token**
   - Click "Generate token"
   - **IMPORTANT**: Copy the token immediately - you won't be able to see it again!
   - It will look like: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

## Add Token to Terraform

### Option 1: Add to terraform.tfvars (Recommended)

Edit `infra/terraform.tfvars` and add:

```hcl
bucket_name      = "quizup-shray-123456"
region           = "us-east-1"
sm_endpoint_name = "quizup-sm-endpoint"

# Amplify Configuration
amplify_repository_url = "https://github.com/shraymoza/quizup.git"
github_oauth_token     = "ghp_your_token_here"  # Your GitHub token
```

**Note:** `terraform.tfvars` is in `.gitignore` and won't be committed to your repository.

### Option 2: Use Environment Variable

Set the token as an environment variable:

**PowerShell:**
```powershell
$env:TF_VAR_github_oauth_token = "ghp_your_token_here"
terraform apply
```

**Bash/Linux:**
```bash
export TF_VAR_github_oauth_token="ghp_your_token_here"
terraform apply
```

### Option 3: Pass as Command Line Argument

```bash
terraform apply -var="github_oauth_token=ghp_your_token_here"
```

## Security Best Practices

1. ✅ **Never commit tokens to Git** - `terraform.tfvars` is in `.gitignore`
2. ✅ **Use minimum required scopes** - Only grant what Amplify needs
3. ✅ **Set expiration** - Rotate tokens regularly
4. ✅ **Use separate tokens** - One token per project/service
5. ✅ **Revoke old tokens** - Delete unused tokens from GitHub

## Alternative: Manual Connection

If you prefer not to use a token in Terraform, you can:

1. Create the Amplify app without repository in Terraform
2. Connect the repository manually in AWS Amplify Console:
   - Go to AWS Amplify Console
   - Select your app
   - Go to "App settings" → "General"
   - Click "Connect branch" and authorize GitHub

However, this requires manual steps and won't be fully automated.

## Troubleshooting

### Error: "You should at least provide one valid token"
- Make sure `github_oauth_token` is set in `terraform.tfvars`
- Verify the token is valid and not expired
- Check that the token has the required scopes

### Error: "Invalid token"
- Regenerate the token in GitHub
- Make sure you copied the entire token (starts with `ghp_`)
- Verify the token hasn't expired

### Token Works but Repository Access Denied
- Check token scopes include `repo` (for private) or `public_repo` (for public)
- Verify you have access to the repository
- Try regenerating the token with correct scopes

