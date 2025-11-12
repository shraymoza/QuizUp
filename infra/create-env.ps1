# Script to create .env.production file with current Terraform outputs
$outputs = terraform output -json | ConvertFrom-Json

# Extract Cognito domain from hosted UI URL if cognito_domain output doesn't exist
$cognitoDomain = ""
if ($outputs.PSObject.Properties.Name -contains "cognito_domain") {
    $cognitoDomain = $outputs.cognito_domain.value
} else {
    # Extract from hosted UI URL: https://quizup-34e3c55c.auth.us-east-1.amazoncognito.com/...
    $hostedUrl = $outputs.cognito_hosted_ui_login_url.value
    if ($hostedUrl -match 'https://([^.]+)\.auth\.') {
        $cognitoDomain = $matches[1]
    }
}

$envContent = @"
VITE_AWS_REGION=us-east-1
VITE_USER_POOL_ID=$($outputs.cognito_user_pool_id.value)
VITE_CLIENT_ID=$($outputs.cognito_client_id.value)
VITE_COGNITO_DOMAIN=$cognitoDomain
VITE_REDIRECT_URI=$($outputs.amplify_branch_url.value)
"@

$envContent | Out-File -FilePath "../frontend/.env.production" -Encoding utf8 -NoNewline

Write-Host "Created .env.production file with values:" -ForegroundColor Green
Write-Host $envContent

