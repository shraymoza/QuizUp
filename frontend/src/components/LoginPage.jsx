import { useState } from 'react';
import { signIn, signUp, confirmSignUp, resendSignUpCode } from '../services/auth';

export function LoginPage() {
  const [mode, setMode] = useState('signin'); // 'signin' or 'signup'
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [confirmationCode, setConfirmationCode] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [needsConfirmation, setNeedsConfirmation] = useState(false);

  async function handleSignIn(e) {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      await signIn({ username: email, password });
      // Redirect will happen via AuthContext
      window.location.reload();
    } catch (err) {
      setError(err.message || 'Failed to sign in');
    } finally {
      setLoading(false);
    }
  }

  async function handleSignUp(e) {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      await signUp({
        username: email,
        password,
        options: {
          userAttributes: {
            email,
            name: name || email,
          },
        },
      });
      setNeedsConfirmation(true);
    } catch (err) {
      setError(err.message || 'Failed to sign up');
    } finally {
      setLoading(false);
    }
  }

  async function handleConfirmSignUp(e) {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      await confirmSignUp({ username: email, confirmationCode });
      setMode('signin');
      setNeedsConfirmation(false);
      setError('');
      alert('Account confirmed! Please sign in.');
    } catch (err) {
      setError(err.message || 'Failed to confirm sign up');
    } finally {
      setLoading(false);
    }
  }

  async function handleResendCode() {
    setLoading(true);
    setError('');

    try {
      await resendSignUpCode({ username: email });
      alert('Confirmation code sent to your email!');
    } catch (err) {
      setError(err.message || 'Failed to resend code');
    } finally {
      setLoading(false);
    }
  }

  if (needsConfirmation) {
    return (
      <div className="login-container">
        <div className="login-card">
          <h2>Confirm Your Email</h2>
          <p>We sent a confirmation code to {email}</p>
          <form onSubmit={handleConfirmSignUp}>
            <input
              type="text"
              placeholder="Confirmation Code"
              value={confirmationCode}
              onChange={(e) => setConfirmationCode(e.target.value)}
              required
            />
            {error && <div className="error">{error}</div>}
            <button type="submit" disabled={loading}>
              {loading ? 'Confirming...' : 'Confirm'}
            </button>
          </form>
          <button type="button" onClick={handleResendCode} disabled={loading} className="link-button">
            Resend Code
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="login-container">
      <div className="login-card">
        <h2>{mode === 'signin' ? 'Sign In' : 'Sign Up'}</h2>
        <form onSubmit={mode === 'signin' ? handleSignIn : handleSignUp}>
          {mode === 'signup' && (
            <input
              type="text"
              placeholder="Name (optional)"
              value={name}
              onChange={(e) => setName(e.target.value)}
            />
          )}
          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            minLength={8}
          />
          {error && <div className="error">{error}</div>}
          <button type="submit" disabled={loading}>
            {loading ? 'Processing...' : mode === 'signin' ? 'Sign In' : 'Sign Up'}
          </button>
        </form>
        <button
          type="button"
          onClick={() => {
            setMode(mode === 'signin' ? 'signup' : 'signin');
            setError('');
          }}
          className="link-button"
        >
          {mode === 'signin' ? "Don't have an account? Sign up" : 'Already have an account? Sign in'}
        </button>
      </div>
    </div>
  );
}

