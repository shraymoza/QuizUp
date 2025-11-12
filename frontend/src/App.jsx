import { useEffect, useState } from 'react'
import LandingPage from './components/LandingPage'
import Dashboard from './components/Dashboard'
import './App.css'

function App() {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Don't auto-login - start on landing page
    setLoading(false)
  }, [])

  const checkAuthStatus = () => {
    // Skip authentication for now - set a mock user to go to dashboard
    setUser({ username: 'guest', signInDetails: { loginId: 'guest@quizup.com' } })
  }

  const handleSignOut = () => {
    // Skip authentication for now - just set user to null
    setUser(null)
  }

  if (loading) {
    return (
      <div className="loading-container">
        <div className="spinner"></div>
        <p>Loading...</p>
      </div>
    )
  }

  return (
    <div className="app">
      {user ? (
        <Dashboard user={user} onSignOut={handleSignOut} />
      ) : (
        <LandingPage onAuthSuccess={checkAuthStatus} />
      )}
    </div>
  )
}

export default App

