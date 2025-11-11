import { signOut } from 'aws-amplify/auth'
import './Dashboard.css'

function Dashboard({ user, onSignOut }) {
  const handleSignOut = async () => {
    try {
      await signOut()
      onSignOut()
    } catch (error) {
      console.error('Error signing out:', error)
    }
  }

  return (
    <div className="dashboard">
      <nav className="dashboard-nav">
        <h1 className="dashboard-logo">Quiz Up</h1>
        <button className="sign-out-button" onClick={handleSignOut}>
          Sign Out
        </button>
      </nav>

      <div className="dashboard-content">
        <div className="welcome-section">
          <h2>Welcome back!</h2>
          <p className="user-email">{user.signInDetails?.loginId || user.username}</p>
          <p className="welcome-message">
            You're successfully authenticated. Ready to start quizzing?
          </p>
        </div>

        <div className="dashboard-cards">
          <div className="dashboard-card">
            <div className="card-icon">🎯</div>
            <h3>Start Quiz</h3>
            <p>Begin a new quiz session</p>
            <button className="card-button">Coming Soon</button>
          </div>

          <div className="dashboard-card">
            <div className="card-icon">📊</div>
            <h3>Your Stats</h3>
            <p>View your quiz history and scores</p>
            <button className="card-button">Coming Soon</button>
          </div>

          <div className="dashboard-card">
            <div className="card-icon">🏅</div>
            <h3>Achievements</h3>
            <p>See your badges and milestones</p>
            <button className="card-button">Coming Soon</button>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Dashboard

