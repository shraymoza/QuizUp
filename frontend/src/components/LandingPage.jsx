import { useState, useEffect } from 'react'
import SignIn from './SignIn'
import SignUp from './SignUp'
import './LandingPage.css'

function LandingPage({ onAuthSuccess }) {
  const [showSignIn, setShowSignIn] = useState(false)
  const [showSignUp, setShowSignUp] = useState(false)

  // Listen for custom events to switch between modals
  useEffect(() => {
    const handleShowSignUp = () => {
      setShowSignUp(true)
      setShowSignIn(false)
    }
    const handleShowSignIn = () => {
      setShowSignIn(true)
      setShowSignUp(false)
    }
    window.addEventListener('showSignUp', handleShowSignUp)
    window.addEventListener('showSignIn', handleShowSignIn)
    return () => {
      window.removeEventListener('showSignUp', handleShowSignUp)
      window.removeEventListener('showSignIn', handleShowSignIn)
    }
  }, [])

  const handleSignInClick = () => {
    setShowSignIn(true)
    setShowSignUp(false)
  }

  const handleSignUpClick = () => {
    setShowSignUp(true)
    setShowSignIn(false)
  }

  const handleClose = () => {
    setShowSignIn(false)
    setShowSignUp(false)
  }

  return (
    <div className="landing-page">
      <div className="landing-content">
        <div className="hero-section">
          <h1 className="hero-title">
            <span className="gradient-text">Quiz Up</span>
          </h1>
          <p className="hero-subtitle">
            Test your knowledge, challenge yourself, and learn something new every day
          </p>
          <div className="cta-buttons">
            <button className="btn btn-primary" onClick={handleSignUpClick}>
              Get Started
            </button>
            <button className="btn btn-secondary" onClick={handleSignInClick}>
              Sign In
            </button>
          </div>
        </div>

        <div className="features-section">
          <div className="feature-card">
            <div className="feature-icon">📚</div>
            <h3>Diverse Topics</h3>
            <p>Quiz on a wide range of subjects and topics</p>
          </div>
          <div className="feature-card">
            <div className="feature-icon">⚡</div>
            <h3>Quick & Fun</h3>
            <p>Fast-paced quizzes to keep you engaged</p>
          </div>
          <div className="feature-card">
            <div className="feature-icon">🏆</div>
            <h3>Track Progress</h3>
            <p>Monitor your performance and improve over timing</p>
          </div>
        </div>
      </div>

      {showSignIn && (
        <div className="modal-overlay" onClick={handleClose}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <button className="close-button" onClick={handleClose}>×</button>
            <SignIn onSuccess={onAuthSuccess} onClose={handleClose} />
          </div>
        </div>
      )}

      {showSignUp && (
        <div className="modal-overlay" onClick={handleClose}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <button className="close-button" onClick={handleClose}>×</button>
            <SignUp onSuccess={onAuthSuccess} onClose={handleClose} />
          </div>
        </div>
      )}
    </div>
  )
}

export default LandingPage

