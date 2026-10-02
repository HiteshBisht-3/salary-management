import {
  BrowserRouter,
  Route,
  Routes,
} from "react-router-dom";

import Layout from "./components/Layout";
import Dashboard from "./pages/Dashboard";
import Employees from "./pages/Employees";
import EmployeeDetails from "./pages/EmployeeDetails";

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<Layout />}>
          <Route path="/" element={<Dashboard />} />
          <Route path="/employees" element={<Employees />} />
          <Route
            path="/employees/:id"
            element={<EmployeeDetails />}
          />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}