// AWS Amplify v6 Configuration
import { Amplify } from 'aws-amplify'

// Fetch variables from .env (injected by Terraform or Amplify Console)
const region = import.meta.env.VITE_AWS_REGION || 'us-east-1'
const userPoolId = import.meta.env.VITE_USER_POOL_ID || import.meta.env.VITE_COGNITO_USER_POOL_ID
const userPoolClientId = import.meta.env.VITE_CLIENT_ID || import.meta.env.VITE_COGNITO_CLIENT_ID
const domain = import.meta.env.VITE_COGNITO_DOMAIN
const redirectUri = import.meta.env.VITE_REDIRECT_URI || window.location.origin

// Validate required configuration
if (!userPoolId || !userPoolClientId) {
  console.error('Cognito configuration missing:', {
    userPoolId: userPoolId || 'MISSING',
    userPoolClientId: userPoolClientId || 'MISSING',
    region,
    domain: domain || 'MISSING',
    redirectUri,
    allEnvVars: {
      VITE_AWS_REGION: import.meta.env.VITE_AWS_REGION,
      VITE_USER_POOL_ID: import.meta.env.VITE_USER_POOL_ID,
      VITE_COGNITO_USER_POOL_ID: import.meta.env.VITE_COGNITO_USER_POOL_ID,
      VITE_CLIENT_ID: import.meta.env.VITE_CLIENT_ID,
      VITE_COGNITO_CLIENT_ID: import.meta.env.VITE_COGNITO_CLIENT_ID,
      VITE_COGNITO_DOMAIN: import.meta.env.VITE_COGNITO_DOMAIN,
      VITE_REDIRECT_URI: import.meta.env.VITE_REDIRECT_URI,
    }
  })
  throw new Error('Auth UserPool not configured. Missing required environment variables.')
}

// Construct full Cognito domain if only domain name is provided
let cognitoDomain = domain
if (domain && !domain.includes('http') && !domain.includes('amazoncognito.com')) {
  cognitoDomain = `https://${domain}.auth.${region}.amazoncognito.com`
} else if (domain && !domain.includes('http')) {
  cognitoDomain = `https://${domain}`
}

const amplifyConfig = {
  Auth: {
    Cognito: {
      userPoolId,
      userPoolClientId,
      loginWith: { email: true },
    },
  },
  region,
}

// Only add OAuth config if domain is provided
if (cognitoDomain) {
  amplifyConfig.Auth.Cognito.oauth = {
    domain: cognitoDomain,
    scopes: ['email', 'openid', 'profile'],
    redirectSignIn: redirectUri,
    redirectSignOut: redirectUri,
    responseType: 'token',
  }
}

Amplify.configure(amplifyConfig)

console.log('Amplify configured successfully:', {
  region,
  userPoolId,
  userPoolClientId: userPoolClientId?.substring(0, 10) + '...',
  domain: cognitoDomain || 'Not configured',
  redirectUri,
})
