# PowerShell script to get Cognito configuration from Terraform outputs
# Run this from the infra directory or update the path below

Write-Host "Getting Cognito configuration from Terraform..." -ForegroundColor Green

$infraPath = Join-Path $PSScriptRoot "..\infra"

if (Test-Path $infraPath) {
    Push-Location $infraPath
    
    Write-Host "`nFetching Terraform outputs..." -ForegroundColor Yellow
    
    $userPoolId = terraform output -raw cognito_user_pool_id 2>$null
    $clientId = terraform output -raw cognito_client_id 2>$null
    
    Pop-Location
    
    if ($userPoolId -and $clientId) {
        Write-Host "`nCognito Configuration:" -ForegroundColor Green
        Write-Host "User Pool ID: $userPoolId" -ForegroundColor Cyan
        Write-Host "Client ID: $clientId" -ForegroundColor Cyan
        
        $envContent = @"
# AWS Cognito Configuration
# Generated from Terraform outputs

VITE_COGNITO_USER_POOL_ID=$userPoolId
VITE_COGNITO_CLIENT_ID=$clientId
VITE_AWS_REGION=us-east-1
"@
        
        $envPath = Join-Path $PSScriptRoot ".env"
        $envContent | Out-File -FilePath $envPath -Encoding utf8
        
        Write-Host "`nConfiguration saved to .env file!" -ForegroundColor Green
        Write-Host "Location: $envPath" -ForegroundColor Yellow
    } else {
        Write-Host "`nError: Could not retrieve Terraform outputs." -ForegroundColor Red
        Write-Host "Make sure you've run 'terraform apply' first." -ForegroundColor Yellow
    }
} else {
    Write-Host "Error: Could not find infra directory at $infraPath" -ForegroundColor Red
}

