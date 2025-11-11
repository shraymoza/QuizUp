# Cognito Callback URL Fix

## Issue
Cognito requires HTTPS for callback URLs (except localhost). The S3 website endpoint uses HTTP, which caused the error:
```
http://quizup-shray-123456.s3-website-us-east-1.amazonaws.com cannot use the HTTP protocol.
```

## Solution
Since we're deploying to AWS Amplify (which uses HTTPS), we've configured:

1. **Initial Callback URLs**: Localhost URLs for local development
   - `http://localhost:3000`
   - `http://localhost:5173` (Vite default)
   - `http://localhost:8080`

2. **After Amplify Creation**: The `null_resource` automatically adds Amplify HTTPS URLs:
   - `https://main.{amplify-domain}`
   - `https://{branch-name}.{amplify-domain}`

## How It Works

1. Cognito is created with localhost URLs (allowed by Cognito)
2. Amplify is created and gets its domain
3. The `null_resource.update_cognito_callbacks` runs and updates Cognito with Amplify HTTPS URLs
4. Both localhost (for dev) and Amplify (for production) URLs are now configured

## Testing

### Local Development
- Run `npm run dev` in the `web/` directory
- Authentication will work with localhost URLs

### Production (Amplify)
- After `terraform apply` completes, Amplify URLs are automatically added
- Your React app deployed on Amplify will use the HTTPS Amplify URLs

## Manual Update (if needed)

If you need to manually update Cognito callback URLs:

```powershell
aws cognito-idp update-user-pool-client `
  --user-pool-id <your-pool-id> `
  --client-id <your-client-id> `
  --callback-urls "http://localhost:3000,http://localhost:5173,https://main.{amplify-domain}" `
  --logout-urls "http://localhost:3000,http://localhost:5173,https://main.{amplify-domain}" `
  --region us-east-1
```

