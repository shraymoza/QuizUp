import { NavLink, Outlet } from "react-router-dom";

export function AppLayout() {
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
      </header>
      <main className="app-main">
        <Outlet />
      </main>
    </div>
  );
}
