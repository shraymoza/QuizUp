###############################################
# Update Cognito Callback URLs with Amplify URLs
# This resource updates Cognito after Amplify is created
# to avoid circular dependency during initial creation
###############################################

# Use AWS CLI to update Cognito callback URLs after Amplify is created
# This runs after Amplify resources are created and adds Amplify URLs to Cognito
resource "null_resource" "update_cognito_callbacks" {
  count = var.amplify_repository_url != "" ? 1 : 0
  
  depends_on = [
    aws_amplify_app.quizup,
    aws_amplify_branch.main,
    aws_cognito_user_pool_client.client
  ]

  triggers = {
    amplify_domain = aws_amplify_app.quizup[0].default_domain
    branch_name    = aws_amplify_branch.main[0].branch_name
    client_id      = aws_cognito_user_pool_client.client.id
    user_pool_id   = aws_cognito_user_pool.pool.id
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Amplify URLs (HTTPS)
      $amplifyUrl1 = "https://main.${aws_amplify_app.quizup[0].default_domain}"
      $amplifyUrl2 = "https://${aws_amplify_branch.main[0].branch_name}.${aws_amplify_app.quizup[0].default_domain}"
      
      # Localhost URLs for local development
      $localhostUrls = @(
        "http://localhost:3000",
        "http://localhost:5173",
        "http://localhost:8080"
      )
      
      # Combine all URLs
      $allCallbackUrls = $localhostUrls + @($amplifyUrl1, $amplifyUrl2)
      $allLogoutUrls = $localhostUrls + @($amplifyUrl1, $amplifyUrl2)
      
      $callbackUrlsString = $allCallbackUrls -join ","
      $logoutUrlsString = $allLogoutUrls -join ","
      
      Write-Host "Updating Cognito callback URLs..." -ForegroundColor Green
      Write-Host "Callback URLs: $callbackUrlsString" -ForegroundColor Cyan
      
      aws cognito-idp update-user-pool-client `
        --user-pool-id ${aws_cognito_user_pool.pool.id} `
        --client-id ${aws_cognito_user_pool_client.client.id} `
        --callback-urls $callbackUrlsString `
        --logout-urls $logoutUrlsString `
        --region ${var.region}
      
      if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully updated Cognito callback URLs!" -ForegroundColor Green
      } else {
        Write-Host "Error updating Cognito callback URLs" -ForegroundColor Red
        exit $LASTEXITCODE
      }
    EOT
    
    interpreter = ["PowerShell", "-Command"]
  }
}

