import { NavLink, Outlet } from "react-router-dom";

export default function Layout() {
  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div>
          <h2>ACME HR</h2>
          <p className="muted">Salary Management</p>
        </div>

        <nav>
          <NavLink to="/">Dashboard</NavLink>
          <NavLink to="/employees">Employees</NavLink>
        </nav>
      </aside>

      <main className="content">
        <Outlet />
      </main>
    </div>
  );
}