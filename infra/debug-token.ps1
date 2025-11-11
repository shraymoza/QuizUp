# Debug script to check if Terraform can read the token
Write-Host "Checking Terraform variables..." -ForegroundColor Green
Write-Host ""

# Check if terraform.tfvars exists
if (Test-Path "terraform.tfvars") {
    Write-Host "✓ terraform.tfvars exists" -ForegroundColor Green
    $content = Get-Content "terraform.tfvars" -Raw
    if ($content -match 'github_oauth_token\s*=\s*"([^"]+)"') {
        $token = $matches[1]
        Write-Host "✓ Token found in terraform.tfvars" -ForegroundColor Green
        Write-Host "  Token length: $($token.Length)" -ForegroundColor Cyan
        Write-Host "  Token starts with: $($token.Substring(0, [Math]::Min(10, $token.Length)))..." -ForegroundColor Cyan
        Write-Host "  Token ends with: ...$($token.Substring([Math]::Max(0, $token.Length - 10)))" -ForegroundColor Cyan
    } else {
        Write-Host "✗ Token not found in terraform.tfvars" -ForegroundColor Red
    }
} else {
    Write-Host "✗ terraform.tfvars does not exist" -ForegroundColor Red
}

Write-Host ""
Write-Host "Testing Terraform variable reading..." -ForegroundColor Green
terraform console -var-file=terraform.tfvars <<< "var.github_oauth_token" 2>&1 | Out-String

