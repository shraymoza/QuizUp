# Quick script to check Amplify status after Learner Lab session restart
# Run this after setting AWS credentials

Write-Host "Checking Amplify App Status..." -ForegroundColor Green
Write-Host ""

# Get app ID from Terraform
try {
    Push-Location $PSScriptRoot
    $appId = terraform output -raw amplify_app_id 2>$null
    $appUrl = terraform output -raw amplify_branch_url 2>$null
    
    if ($appId -and $appId -ne "Not configured - set amplify_repository_url variable") {
        Write-Host "✅ Amplify App ID: $appId" -ForegroundColor Green
        
        # Check if app exists in AWS
        $appInfo = aws amplify get-app --app-id $appId --region us-east-1 2>&1 | ConvertFrom-Json
        
        if ($appInfo) {
            Write-Host "✅ App exists in AWS" -ForegroundColor Green
            Write-Host "   Name: $($appInfo.app.name)" -ForegroundColor Cyan
            Write-Host "   Repository: $($appInfo.app.repository)" -ForegroundColor Cyan
            
            if ($appInfo.app.repository) {
                Write-Host "✅ Repository connected" -ForegroundColor Green
            } else {
                Write-Host "⚠️  Repository NOT connected" -ForegroundColor Yellow
                Write-Host "   Go to: https://console.aws.amazon.com/amplify" -ForegroundColor Yellow
                Write-Host "   Click on your app and connect repository" -ForegroundColor Yellow
            }
            
            # Check branches
            $branches = aws amplify list-branches --app-id $appId --region us-east-1 2>&1 | ConvertFrom-Json
            if ($branches.branches) {
                Write-Host "✅ Branches:" -ForegroundColor Green
                foreach ($branch in $branches.branches) {
                    $status = $branch.activeJob
                    Write-Host "   - $($branch.branchName): $status" -ForegroundColor Cyan
                }
            }
            
            Write-Host ""
            Write-Host "🌐 Your App URL: $appUrl" -ForegroundColor Green
            Write-Host ""
            Write-Host "To open in browser:" -ForegroundColor Yellow
            Write-Host "  Start-Process '$appUrl'" -ForegroundColor Cyan
            
        } else {
            Write-Host "❌ App not found in AWS" -ForegroundColor Red
            Write-Host "   Run: terraform apply" -ForegroundColor Yellow
        }
    } else {
        Write-Host "⚠️  Amplify not configured" -ForegroundColor Yellow
        Write-Host "   Set amplify_repository_url in terraform.tfvars" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Error checking Amplify status" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Make sure:" -ForegroundColor Yellow
    Write-Host "  1. AWS credentials are set (run set-aws-env.ps1)" -ForegroundColor Yellow
    Write-Host "  2. You're in the infra directory" -ForegroundColor Yellow
    Write-Host "  3. Terraform has been applied" -ForegroundColor Yellow
} finally {
    Pop-Location
}

