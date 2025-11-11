# Deployment Information

## Amplify Deployment Time

**First Build:** 5-15 minutes
- Initial build includes:
  - Installing dependencies (`npm install`)
  - Building the React app (`npm run build`)
  - Deploying to Amplify CDN

**Subsequent Builds:** 2-5 minutes
- Faster because of caching
- Only rebuilds changed files

### Check Deployment Status

1. **AWS Amplify Console:**
   - Go to: https://console.aws.amazon.com/amplify
   - Find your app: `quizup-web`
   - Check the "Deployments" tab for build status

2. **Your App URL:**
   ```
   https://main.dapniwx8l3avh.amplifyapp.com
   ```

3. **Monitor Build:**
   - Click on your app in Amplify Console
   - View real-time build logs
   - See deployment progress

## S3 Static Website Removal

The S3 static website hosting has been removed from the infrastructure. Here's what changed:

### Removed Resources:
- ✅ `aws_s3_bucket_website_configuration` - Website hosting configuration
- ✅ `aws_s3_bucket_policy` (public_read) - Public read access policy
- ✅ `website_url` output - No longer needed

### Kept Resources:
- ✅ `aws_s3_bucket` - Still needed for Lambda function storage
- ✅ Bucket encryption and folders - Still in use

### Security Improvements:
- ✅ Public access is now blocked (bucket is private)
- ✅ Bucket is only accessible by Lambda functions

### Next Steps:

Run `terraform apply` to remove the S3 website resources:

```powershell
cd infra
terraform apply
```

This will:
1. Remove the S3 website configuration
2. Remove the public read policy
3. Block all public access to the bucket
4. Update outputs to remove `website_url`

**Note:** The S3 bucket itself will remain (it's used by your Lambda functions), but it will no longer be publicly accessible or configured as a website.

## Current Infrastructure

### Active Services:
- ✅ **AWS Amplify** - Hosting your React app
- ✅ **Amazon Cognito** - User authentication
- ✅ **API Gateway** - Backend API
- ✅ **Lambda Functions** - Backend logic
- ✅ **S3 Bucket** - Private storage for Lambda
- ✅ **SageMaker** - ML model endpoint

### Your App URLs:
- **Production:** https://main.dapniwx8l3avh.amplifyapp.com
- **Local Dev:** http://localhost:5173 (or 3000, 8080)

## After Deployment

Once Amplify finishes building:

1. **Visit your app:** https://main.dapniwx8l3avh.amplifyapp.com
2. **Test authentication:**
   - Click "Get Started" to sign up
   - Verify your email
   - Sign in
3. **Check Cognito:**
   - Users will be created in your Cognito User Pool
   - Authentication works with both localhost (dev) and Amplify (prod)

## Troubleshooting

### Build Fails:
- Check build logs in Amplify Console
- Verify `package.json` is in `web/` directory
- Ensure all dependencies are listed

### Authentication Not Working:
- Verify Cognito callback URLs include your Amplify domain
- Check environment variables in Amplify (should be auto-set by Terraform)
- Ensure your React app is using the correct Cognito config

### S3 Website Still Accessible:
- Run `terraform apply` to remove it
- The old S3 website URL will stop working after removal

