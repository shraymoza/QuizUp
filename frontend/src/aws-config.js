// AWS Amplify v6 Configuration
import { Amplify } from 'aws-amplify'

// Fetch variables from .env (injected by Terraform or Amplify Console)
const region = import.meta.env.VITE_AWS_REGION || 'us-east-1'
const userPoolId = import.meta.env.VITE_USER_POOL_ID || import.meta.env.VITE_COGNITO_USER_POOL_ID
const userPoolClientId = import.meta.env.VITE_CLIENT_ID || import.meta.env.VITE_COGNITO_CLIENT_ID
const domain = import.meta.env.VITE_COGNITO_DOMAIN
const redirectUri = import.meta.env.VITE_REDIRECT_URI || 'http://localhost:3000'

Amplify.configure({
  Auth: {
    Cognito: {
      userPoolId,
      userPoolClientId,
      loginWith: { email: true },
      oauth: {
        domain,
        scopes: ['email', 'openid', 'profile'],
        redirectSignIn: redirectUri,
        redirectSignOut: redirectUri,
        responseType: 'token',
      },
    },
  },
  region,
})
