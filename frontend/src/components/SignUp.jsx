import { useState } from 'react'
import { signUp, confirmSignUp } from 'aws-amplify/auth'
import './Auth.css'

function SignUp({ onSuccess, onClose }) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [confirmationCode, setConfirmationCode] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const [needsConfirmation, setNeedsConfirmation] = useState(false)

  const handleSignUp = async (e) => {
    e.preventDefault()
    setError('')

    if (password !== confirmPassword) {
      setError('Passwords do not match')
      return
    }

    if (password.length < 8) {
      setError('Password must be at least 8 characters long')
      return
    }

    setLoading(true)

    try {
      await signUp({
        username: email,
        password: password,
        options: {
          userAttributes: {
            email: email,
          },
        },
      })
      setNeedsConfirmation(true)
    } catch (err) {
      setError(err.message || 'Failed to sign up. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  const handleConfirmSignUp = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      await confirmSignUp({
        username: email,
        confirmationCode: confirmationCode,
      })
      onSuccess()
    } catch (err) {
      setError(err.message || 'Invalid confirmation code. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  if (needsConfirmation) {
    return (
      <div className="auth-container">
        <h2>Confirm Your Email</h2>
        <p className="auth-subtitle">
          We've sent a confirmation code to {email}. Please enter it below.
        </p>

        <form onSubmit={handleConfirmSignUp} className="auth-form">
          {error && <div className="error-message">{error}</div>}

          <div className="form-group">
            <label htmlFor="confirmationCode">Confirmation Code</label>
            <input
              id="confirmationCode"
              type="text"
              value={confirmationCode}
              onChange={(e) => setConfirmationCode(e.target.value)}
              required
              placeholder="Enter confirmation code"
              disabled={loading}
            />
          </div>

          <button type="submit" className="auth-button" disabled={loading}>
            {loading ? 'Confirming...' : 'Confirm Sign Up'}
          </button>
        </form>

        <p className="auth-footer">
          <button
            className="link-button"
            onClick={() => setNeedsConfirmation(false)}
            disabled={loading}
          >
            Back to sign up
          </button>
        </p>
      </div>
    )
  }

  return (
    <div className="auth-container">
      <h2>Create Account</h2>
      <p className="auth-subtitle">Join Quiz Up and start testing your knowledge</p>

      <form onSubmit={handleSignUp} className="auth-form">
        {error && <div className="error-message">{error}</div>}

        <div className="form-group">
          <label htmlFor="email">Email</label>
          <input
            id="email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            placeholder="Enter your email"
            disabled={loading}
          />
        </div>

        <div className="form-group">
          <label htmlFor="password">Password</label>
          <input
            id="password"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            placeholder="At least 8 characters"
            disabled={loading}
            minLength={8}
          />
        </div>

        <div className="form-group">
          <label htmlFor="confirmPassword">Confirm Password</label>
          <input
            id="confirmPassword"
            type="password"
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            required
            placeholder="Confirm your password"
            disabled={loading}
          />
        </div>

        <button type="submit" className="auth-button" disabled={loading}>
          {loading ? 'Creating account...' : 'Sign Up'}
        </button>
      </form>

      <p className="auth-footer">
        Already have an account?{' '}
        <button 
          className="link-button" 
          onClick={() => {
            onClose()
            // Trigger sign in modal
            setTimeout(() => {
              window.dispatchEvent(new CustomEvent('showSignIn'))
            }, 100)
          }}
        >
          Sign in instead
        </button>
      </p>
    </div>
  )
}

export default SignUp

