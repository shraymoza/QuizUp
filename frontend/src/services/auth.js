import { Amplify } from 'aws-amplify';
import { signIn, signOut, signUp, confirmSignUp, resendSignUpCode, getCurrentUser, fetchAuthSession } from 'aws-amplify/auth';

// Configure Amplify with Cognito
const cognitoConfig = {
  Auth: {
    Cognito: {
      userPoolId: import.meta.env.VITE_COGNITO_USER_POOL_ID,
      userPoolClientId: import.meta.env.VITE_COGNITO_CLIENT_ID,
      region: import.meta.env.VITE_COGNITO_REGION || 'us-east-1',
      loginWith: {
        oauth: {
          domain: import.meta.env.VITE_COGNITO_DOMAIN,
          scopes: ['email', 'openid', 'profile'],
          redirectSignIn: [window.location.origin],
          redirectSignOut: [window.location.origin],
          responseType: 'code',
        },
      },
    },
  },
};

// Initialize Amplify
Amplify.configure(cognitoConfig);

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

