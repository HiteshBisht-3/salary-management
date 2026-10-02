import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import EmployeeForm from "../components/EmployeeForm";
import { employeesApi } from "../api/api";

export default function Employees() {
  const [employees, setEmployees] = useState([]);
  const [meta, setMeta] = useState({});
  const [page, setPage] = useState(1);

  const [search, setSearch] = useState("");
  const [department, setDepartment] = useState("");
  const [country, setCountry] = useState("");

  const [showForm, setShowForm] = useState(false);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);

  async function loadEmployees(targetPage = page) {
    try {
      setLoading(true);
      setError("");

      const response = await employeesApi.list({
        page: targetPage,
        per_page: 20,
        search,
        department,
        country,
        sort: "employee_code",
        direction: "asc",
      });

      setEmployees(response.data);
      setMeta(response.meta);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    loadEmployees(page);
  }, [page]);

  async function handleSearch(event) {
    event.preventDefault();

    setPage(1);
    await loadEmployees(1);
  }

  async function createEmployee(employee) {
    try {
      setError("");

      await employeesApi.create(employee);

      setShowForm(false);
      setPage(1);

      await loadEmployees(1);
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <>
      <div className="page-header">
        <div>
          <h1>Employees</h1>
          <p className="muted">
            Search and manage employee information.
          </p>
        </div>

        <button onClick={() => setShowForm(!showForm)}>
          {showForm ? "Close" : "Add Employee"}
        </button>
      </div>

      {error && <div className="error">{error}</div>}

      {showForm && (
        <section className="card">
          <h2>Add Employee</h2>

          <EmployeeForm
            onSubmit={createEmployee}
            onCancel={() => setShowForm(false)}
          />
        </section>
      )}

      <section className="card">
        <form className="filters" onSubmit={handleSearch}>
          <input
            placeholder="Search name, email or employee code"
            value={search}
            onChange={(event) => setSearch(event.target.value)}
          />

          <input
            placeholder="Department"
            value={department}
            onChange={(event) => setDepartment(event.target.value)}
          />

          <input
            placeholder="Country"
            value={country}
            onChange={(event) => setCountry(event.target.value)}
          />

          <button type="submit">Search</button>
        </form>
      </section>

      <section className="card">
        {loading ? (
          <p>Loading employees...</p>
        ) : employees.length === 0 ? (
          <p>No employees found.</p>
        ) : (
          <div className="table-wrapper">
            <table>
              <thead>
                <tr>
                  <th>Code</th>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Department</th>
                  <th>Country</th>
                  <th>Job Title</th>
                  <th />
                </tr>
              </thead>

              <tbody>
                {employees.map((employee) => (
                  <tr key={employee.id}>
                    <td>{employee.employee_code}</td>

                    <td>
                      {employee.first_name} {employee.last_name}
                    </td>

                    <td>{employee.email}</td>
                    <td>{employee.department}</td>
                    <td>{employee.country}</td>
                    <td>{employee.job_title}</td>

                    <td>
                      <Link to={`/employees/${employee.id}`}>
                        View
                      </Link>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}

        <div className="pagination">
          <button
            className="secondary"
            disabled={page <= 1}
            onClick={() => setPage(page - 1)}
          >
            Previous
          </button>

          <span>
            Page {meta.current_page || 1} of {meta.total_pages || 1}
          </span>

          <button
            className="secondary"
            disabled={page >= (meta.total_pages || 1)}
            onClick={() => setPage(page + 1)}
          >
            Next
          </button>
        </div>
      </section>
    </>
  );
}