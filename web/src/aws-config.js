// AWS Amplify Configuration
// Replace these values with your actual Cognito User Pool ID and Client ID
// You can get these from Terraform outputs: terraform output cognito_user_pool_id and cognito_client_id

const userPoolId = import.meta.env.VITE_COGNITO_USER_POOL_ID || 'YOUR_USER_POOL_ID'
const userPoolClientId = import.meta.env.VITE_COGNITO_CLIENT_ID || 'YOUR_CLIENT_ID'
const region = import.meta.env.VITE_AWS_REGION || 'us-east-1'

export const awsConfig = {
  Auth: {
    Cognito: {
      userPoolId: userPoolId,
      userPoolClientId: userPoolClientId,
      loginWith: {
        email: true,
      },
    },
  },
  region: region,
}

