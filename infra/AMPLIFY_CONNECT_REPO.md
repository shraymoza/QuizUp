# Connect Repository to Amplify App

## Why is the Amplify Console Empty?

Terraform created your Amplify app, but the **repository connection** needs to be completed manually in the AWS Console. This is a one-time setup step.

## Step-by-Step Instructions

### 1. Go to AWS Amplify Console

Visit: https://console.aws.amazon.com/amplify/home?region=us-east-1

### 2. Find Your App

- Look for an app named **`quizup-web`**
- If you don't see it, make sure you're in the **us-east-1** region (top right corner)

### 3. Connect the Repository

1. **Click on your app** (`quizup-web`)
2. You'll see a message like "Connect a branch to start deploying"
3. **Click "Connect branch"** button
4. You'll see options:
   - **GitHub** (recommended)
   - GitLab
   - Bitbucket
   - AWS CodeCommit

### 4. Authorize GitHub (if using GitHub)

1. Click **"GitHub"**
2. Click **"Authorize"** or **"Install"**
3. You may need to:
   - Sign in to GitHub
   - Authorize AWS Amplify to access your repositories
   - Select the repository: `shraymoza/quizup`
   - Click "Install" or "Authorize"

### 5. Select Branch

1. After authorization, select your branch: **`main`** (or `master`)
2. Click **"Next"**

### 6. Review Build Settings

Amplify should auto-detect your build settings:
- **Build command:** `cd web && npm install && npm run build`
- **Output directory:** `web/dist`

If it doesn't auto-detect, you can manually set:
- **Base directory:** Leave empty (or `/`)
- **Build commands:**
  ```
  cd web
  npm install
  npm run build
  ```
- **Output directory:** `web/dist`

### 7. Environment Variables

The environment variables should already be set by Terraform:
- `VITE_COGNITO_USER_POOL_ID`
- `VITE_COGNITO_CLIENT_ID`
- `VITE_AWS_REGION`

**Verify these are present** in the Amplify Console under "Environment variables"

### 8. Save and Deploy

1. Click **"Save and deploy"**
2. Amplify will start building your app
3. You'll see build progress in real-time

## After Connection

Once connected, you'll see:
- ✅ Your app in the Amplify Console
- ✅ Build history
- ✅ Deployment status
- ✅ Your app URL: `https://main.dapniwx8l3avh.amplifyapp.com`

## Troubleshooting

### "App not found"
- Check you're in the correct AWS region (us-east-1)
- Verify Terraform created the app: `terraform output amplify_app_id`

### "Repository access denied"
- Make sure you authorized AWS Amplify in GitHub
- Check that the repository is accessible
- Verify the repository URL matches: `https://github.com/shraymoza/quizup.git`

### "Build fails"
- Check build logs in Amplify Console
- Verify `package.json` exists in `web/` directory
- Ensure all dependencies are listed in `package.json`

### "Environment variables missing"
- They should be auto-set by Terraform
- If missing, add them manually in Amplify Console:
  - Go to App settings → Environment variables
  - Add:
    - `VITE_COGNITO_USER_POOL_ID` = `us-east-1_i5HQKdPFT`
    - `VITE_COGNITO_CLIENT_ID` = `58844nfiefgedgbtrg9ac9tbe`
    - `VITE_AWS_REGION` = `us-east-1`

## Next Steps After Connection

1. **Wait for first build** (5-15 minutes)
2. **Visit your app:** https://main.dapniwx8l3avh.amplifyapp.com
3. **Test authentication:**
   - Click "Get Started" to sign up
   - Verify email
   - Sign in

## Automatic Deployments

After the initial connection, Amplify will automatically:
- ✅ Build and deploy on every push to `main` branch
- ✅ Show build status in the console
- ✅ Provide preview URLs for pull requests (if configured)

