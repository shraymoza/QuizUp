# Helper script to assume LabRole and set environment variables
# Run this before terraform apply if you prefer manual role assumption

$accountId = "547655624989"  # Update with your account ID if different
$roleArn = "arn:aws:iam::${accountId}:role/LabRole"

Write-Host "Assuming LabRole: $roleArn" -ForegroundColor Yellow

$assumeRoleOutput = aws sts assume-role --role-arn $roleArn --role-session-name terraform-session | ConvertFrom-Json

if ($assumeRoleOutput.Credentials) {
    $env:AWS_ACCESS_KEY_ID     = $assumeRoleOutput.Credentials.AccessKeyId
    $env:AWS_SECRET_ACCESS_KEY = $assumeRoleOutput.Credentials.SecretAccessKey
    $env:AWS_SESSION_TOKEN     = $assumeRoleOutput.Credentials.SessionToken
    $env:AWS_DEFAULT_REGION     = "us-east-1"
    
    Write-Host "Successfully assumed LabRole!" -ForegroundColor Green
    Write-Host "Identity: $(aws sts get-caller-identity | ConvertFrom-Json | ConvertTo-Json -Compress)" -ForegroundColor Cyan
    
    Write-Host "`nYou can now run: terraform apply" -ForegroundColor Yellow
} else {
    Write-Host "Failed to assume role. Check your credentials and role ARN." -ForegroundColor Red
    exit 1
}

