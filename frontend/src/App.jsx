import { useEffect, useState } from 'react'
import { Amplify } from 'aws-amplify'
import { getCurrentUser, signOut } from 'aws-amplify/auth'
import { awsConfig } from './aws-config'
import LandingPage from './components/LandingPage'
import Dashboard from './components/Dashboard'
import './App.css'

// Configure Amplify
Amplify.configure(awsConfig)

function App() {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    checkAuthStatus()
  }, [])

  const checkAuthStatus = async () => {
    try {
      const currentUser = await getCurrentUser()
      setUser(currentUser)
    } catch (error) {
      setUser(null)
    } finally {
      setLoading(false)
    }
  }

  const handleSignOut = async () => {
    try {
      await signOut()
      setUser(null)
    } catch (error) {
      console.error('Error signing out:', error)
    }
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

