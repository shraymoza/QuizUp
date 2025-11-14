import { createContext, useContext, useState, useEffect } from 'react';
import { getCurrentUser, fetchAuthSession, signOut as cognitoSignOut } from 'aws-amplify/auth';
import { getIdToken, isAuthenticated } from '../services/auth';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [token, setToken] = useState(null);

  useEffect(() => {
    checkAuth();
  }, []);

  async function checkAuth() {
    try {
      const authenticated = await isAuthenticated();
      if (authenticated) {
        const currentUser = await getCurrentUser();
        const idToken = await getIdToken();
        setUser(currentUser);
        setToken(idToken);
      } else {
        setUser(null);
        setToken(null);
      }
    } catch (error) {
      console.error('Error checking auth:', error);
      setUser(null);
      setToken(null);
    } finally {
      setLoading(false);
    }
  }

  async function signOut() {
    try {
      await cognitoSignOut();
      setUser(null);
      setToken(null);
    } catch (error) {
      console.error('Error signing out:', error);
    }
  }

  async function refreshToken() {
    try {
      const session = await fetchAuthSession({ forceRefresh: true });
      const idToken = session.tokens?.idToken?.toString();
      setToken(idToken);
      return idToken;
    } catch (error) {
      console.error('Error refreshing token:', error);
      return null;
    }
  }

  return (
    <AuthContext.Provider value={{ user, token, loading, signOut, refreshToken, checkAuth }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
}

