import { Amplify } from 'aws-amplify';
import { signIn, signOut, signUp, confirmSignUp, resendSignUpCode, getCurrentUser, fetchAuthSession } from 'aws-amplify/auth';

// Get environment variables with fallbacks
const getUserPoolId = () => import.meta.env.VITE_COGNITO_USER_POOL_ID || '';
const getClientId = () => import.meta.env.VITE_COGNITO_CLIENT_ID || '';
const getRegion = () => import.meta.env.VITE_COGNITO_REGION || 'us-east-1';
const getDomain = () => import.meta.env.VITE_COGNITO_DOMAIN || '';

// Configure Amplify with Cognito (only if required values are present)
const userPoolId = getUserPoolId();
const clientId = getClientId();
const region = getRegion();
const domain = getDomain();

if (userPoolId && clientId) {
  const cognitoConfig = {
    Auth: {
      Cognito: {
        userPoolId: userPoolId,
        userPoolClientId: clientId,
        region: region,
        loginWith: domain ? {
          oauth: {
            domain: domain,
            scopes: ['email', 'openid', 'profile'],
            redirectSignIn: [window.location.origin],
            redirectSignOut: [window.location.origin],
            responseType: 'code',
          },
        } : undefined,
      },
    },
  };

  // Initialize Amplify
  Amplify.configure(cognitoConfig);
} else {
  console.warn('Cognito configuration incomplete. Some environment variables may be missing.');
}

// Export auth functions
export { signIn, signOut, signUp, confirmSignUp, resendSignUpCode, getCurrentUser, fetchAuthSession };

// Helper to get ID token for API calls
export async function getIdToken() {
  try {
    const session = await fetchAuthSession();
    return session.tokens?.idToken?.toString();
  } catch (error) {
    console.error('Error getting ID token:', error);
    return null;
  }
}

// Helper to check if user is authenticated
export async function isAuthenticated() {
  try {
    const user = await getCurrentUser();
    return user !== null;
  } catch (error) {
    return false;
  }
}

