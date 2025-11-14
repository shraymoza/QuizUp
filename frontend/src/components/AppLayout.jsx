import { NavLink, Outlet } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";

export function AppLayout() {
  const { user, signOut, loading } = useAuth();

  if (loading) {
    return (
      <div className="app-shell">
        <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
          Loading...
        </div>
      </div>
    );
  }

  return (
    <div className="app-shell">
      <header className="app-header">
        <div className="brand">
          <span className="brand-accent">Quiz</span>Up
        </div>
        <nav className="app-nav">
          <NavLink to="/upload" className={({ isActive }) => (isActive ? "active" : "")}>Upload</NavLink>
          <NavLink to="/history" className={({ isActive }) => (isActive ? "active" : "")}>History</NavLink>
        </nav>
        <div className="user-menu">
          {user ? (
            <>
              <span className="user-email">{user.signInDetails?.loginId || user.username}</span>
              <button onClick={signOut} className="sign-out-button">Sign Out</button>
            </>
          ) : (
            <NavLink to="/login" className="sign-in-link">Sign In</NavLink>
          )}
        </div>
      </header>
      <main className="app-main">
        <Outlet />
      </main>
    </div>
  );
}
