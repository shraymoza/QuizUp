import { useState } from 'react'
import { signIn } from 'aws-amplify/auth'
import './Auth.css'

function SignIn({ onSuccess, onClose }) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      await signIn({
        username: email,
        password: password,
      })
      // Sign in successful, check auth status
      onSuccess()
    } catch (err) {
      setError(err.message || 'Failed to sign in. Please check your credentials.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="auth-container">
      <h2>Welcome Back</h2>
      <p className="auth-subtitle">Sign in to continue to Quiz Up</p>

      <form onSubmit={handleSubmit} className="auth-form">
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
            placeholder="Enter your password"
            disabled={loading}
          />
        </div>

        <button type="submit" className="auth-button" disabled={loading}>
          {loading ? 'Signing in...' : 'Sign In'}
        </button>
      </form>

      <p className="auth-footer">
        Don't have an account?{' '}
        <button 
          className="link-button" 
          onClick={() => {
            onClose()
            // Trigger sign up modal
            setTimeout(() => {
              window.dispatchEvent(new CustomEvent('showSignUp'))
            }, 100)
          }}
        >
          Sign up instead
        </button>
      </p>
    </div>
  )
}

export default SignIn

