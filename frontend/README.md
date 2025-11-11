# Quiz Up - Web Application

A modern React web application for Quiz Up with AWS Cognito authentication.

## Features

- 🎨 Beautiful, modern UI with gradient design
- 🔐 AWS Cognito authentication (Sign Up & Sign In)
- 📱 Responsive design for all devices
- ⚡ Built with Vite for fast development
- 🚀 Ready for AWS Amplify deployment

## Prerequisites

- Node.js 18+ and npm
- AWS Cognito User Pool (configured via Terraform)
- AWS credentials configured

## Setup

1. **Install dependencies:**
   ```bash
   cd web
   npm install
   ```

2. **Configure AWS Cognito:**
   
   Get your Cognito User Pool ID and Client ID from Terraform outputs:
   ```bash
   cd ../infra
   terraform output cognito_user_pool_id
   terraform output cognito_client_id
   ```

3. **Create environment file:**
   
   Copy `.env.example` to `.env` and fill in your values:
   ```bash
   cp .env.example .env
   ```
   
   Then edit `.env` with your actual Cognito values.

4. **Run development server:**
   ```bash
   npm run dev
   ```

5. **Build for production:**
   ```bash
   npm run build
   ```

## Deployment to AWS Amplify

1. Push your code to a Git repository (GitHub, GitLab, or Bitbucket)

2. In AWS Amplify Console:
   - Click "New app" > "Host web app"
   - Connect your repository
   - Configure build settings:
     - Build command: `npm run build`
     - Output directory: `dist`
   - Add environment variables:
     - `VITE_COGNITO_USER_POOL_ID`
     - `VITE_COGNITO_CLIENT_ID`
     - `VITE_AWS_REGION`

3. Update Cognito callback URLs in Terraform to include your Amplify domain

## Project Structure

```
web/
├── src/
│   ├── components/
│   │   ├── LandingPage.jsx    # Main landing page
│   │   ├── SignIn.jsx         # Sign in component
│   │   ├── SignUp.jsx         # Sign up component
│   │   └── Dashboard.jsx      # Post-authentication dashboard
│   ├── App.jsx                # Main app component
│   ├── main.jsx              # Entry point
│   ├── aws-config.js        # AWS Amplify configuration
│   ├── index.css            # Global styles
│   └── App.css              # App-specific styles
├── index.html
├── package.json
├── vite.config.js
└── README.md
```

## Authentication Flow

1. User visits landing page
2. Clicks "Get Started" or "Sign In"
3. Modal opens with sign up/sign in form
4. User signs up → receives confirmation code → confirms email
5. User signs in → redirected to dashboard
6. Authenticated users see dashboard with quiz options

## Notes

- The app uses AWS Amplify Auth library for Cognito integration
- Password requirements: minimum 8 characters (as configured in Cognito)
- Email verification is required for new sign-ups
- All authentication state is managed by AWS Amplify

