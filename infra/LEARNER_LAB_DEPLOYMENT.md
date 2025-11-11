# AWS Learner Lab - Amplify Deployment Guide

## Understanding AWS Learner Lab Sessions

AWS Learner Lab sessions are **temporary** (typically 4 hours), but **resources created persist** across sessions until:
- The lab environment is reset (usually weekly/monthly)
- You manually delete resources
- The lab account expires

## What Happens After Session Restart?

### ✅ Resources That Persist:
- **Amplify App** - Created by Terraform, persists across sessions
- **Cognito User Pool** - Persists
- **S3 Buckets** - Persist
- **Lambda Functions** - Persist
- **API Gateway** - Persists
- **All Terraform-managed resources** - Persist

### ⚠️ What Might Need Reconnection:
- **Repository Connection** - May need to reconnect if:
  - GitHub authorization expires
  - AWS Amplify loses the connection
  - Session was inactive for a long time

## Deployment Workflow

### First Time Setup (One-Time):
1. Run `terraform apply` to create infrastructure
2. Manually connect repository in Amplify Console (one-time)
3. App builds and deploys automatically

### After Session Restart:

**Option 1: Repository Already Connected (Most Common)**
- ✅ **Nothing needed!** Amplify will automatically:
  - Detect new commits
  - Build and deploy automatically
  - Your app stays live

**Option 2: Repository Connection Lost**
- Go to Amplify Console
- Click "Connect branch" again
- Re-authorize GitHub (if needed)
- Select branch and deploy

## Automated Reconnection Script

If you frequently need to reconnect, you can use this script:

```powershell
# reconnect-amplify.ps1
# Run this after starting a new Learner Lab session

Write-Host "Checking Amplify app status..." -ForegroundColor Green

$appId = terraform -chdir=infra output -raw amplify_app_id
$appUrl = terraform -chdir=infra output -raw amplify_branch_url

Write-Host "App ID: $appId" -ForegroundColor Cyan
Write-Host "App URL: $appUrl" -ForegroundColor Cyan

# Check if app exists
aws amplify get-app --app-id $appId --region us-east-1 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Amplify app exists" -ForegroundColor Green
    
    # Check repository connection
    $appInfo = aws amplify get-app --app-id $appId --region us-east-1 | ConvertFrom-Json
    $repoUrl = $appInfo.app.repository
    
    if ($repoUrl) {
        Write-Host "✅ Repository connected: $repoUrl" -ForegroundColor Green
        Write-Host "✅ No action needed - app should auto-deploy on commits" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Repository not connected" -ForegroundColor Yellow
        Write-Host "   Go to: https://console.aws.amazon.com/amplify" -ForegroundColor Yellow
        Write-Host "   Click on app and connect repository" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Amplify app not found" -ForegroundColor Red
    Write-Host "   Run: terraform apply" -ForegroundColor Yellow
}
```

## Best Practices for Learner Lab

### 1. Keep Terraform State
- ✅ Terraform state persists (stored in S3 or locally)
- ✅ Run `terraform apply` only if resources were deleted
- ✅ Most of the time, just reconnect repository if needed

### 2. Repository Connection
- ✅ Once connected, it usually persists
- ✅ GitHub authorization might expire (rare)
- ✅ If connection lost, reconnect in console (takes 2 minutes)

### 3. Automatic Deployments
- ✅ After initial setup, Amplify auto-deploys on every Git push
- ✅ No manual deployment needed
- ✅ Just push code to GitHub, Amplify builds automatically

### 4. Quick Check After Session Start

Run this to verify everything is working:

```powershell
cd infra

# Check if app exists
terraform output amplify_app_id

# Check app status
$appId = terraform output -raw amplify_app_id
aws amplify get-app --app-id $appId --region us-east-1

# Visit your app
$appUrl = terraform output -raw amplify_branch_url
Write-Host "Your app: $appUrl" -ForegroundColor Green
Start-Process $appUrl
```

## Typical Workflow After Session Restart

### Scenario 1: Everything Works (90% of cases)
1. ✅ Start new Learner Lab session
2. ✅ Set AWS credentials: `.\set-aws-env.ps1`
3. ✅ Visit your app: https://main.dapniwx8l3avh.amplifyapp.com
4. ✅ **That's it!** App is live and working

### Scenario 2: Need to Reconnect Repository (10% of cases)
1. ✅ Start new Learner Lab session
2. ✅ Set AWS credentials: `.\set-aws-env.ps1`
3. ⚠️ Go to Amplify Console
4. ⚠️ Click "Connect branch"
5. ⚠️ Re-authorize GitHub
6. ✅ App builds automatically

### Scenario 3: Resources Deleted (Rare)
1. ✅ Start new Learner Lab session
2. ✅ Set AWS credentials: `.\set-aws-env.ps1`
3. ✅ Run `terraform apply` to recreate everything
4. ✅ Connect repository in console
5. ✅ App builds and deploys

## Summary

**Short Answer:** No, you don't need to manually deploy each time.

**What Actually Happens:**
- ✅ Amplify app persists across sessions
- ✅ Repository connection usually persists
- ✅ App auto-deploys on Git commits
- ⚠️ Only reconnect repository if connection is lost (rare)

**After Session Restart:**
1. Set AWS credentials
2. Check if app is accessible
3. If not, reconnect repository (takes 2 minutes)
4. That's it!

The beauty of Infrastructure as Code (Terraform) + Amplify is that once set up, it mostly "just works" across sessions!

