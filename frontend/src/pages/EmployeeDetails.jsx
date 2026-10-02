import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";

import EmployeeForm from "../components/EmployeeForm";
import SalaryForm from "../components/SalaryForm";
import { employeesApi } from "../api/api";

export default function EmployeeDetails() {
  const { id } = useParams();
  const navigate = useNavigate();

  const [employee, setEmployee] = useState(null);
  const [salaries, setSalaries] = useState([]);
  const [editing, setEditing] = useState(false);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  async function load() {
    try {
      setLoading(true);
      setError("");

      const [employeeData, salaryData] = await Promise.all([
        employeesApi.get(id),
        employeesApi.salaries(id),
      ]);

      setEmployee(employeeData);
      setSalaries(salaryData);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
  }, [id]);

  async function updateEmployee(values) {
    try {
      const updated = await employeesApi.update(id, values);

      setEmployee(updated);
      setEditing(false);
      setError("");
    } catch (err) {
      setError(err.message);
    }
  }

  async function addSalary(values) {
    try {
      await employeesApi.addSalary(id, values);
      setError("");

      const salaryData = await employeesApi.salaries(id);
      setSalaries(salaryData);
    } catch (err) {
      setError(err.message);
    }
  }

  async function deleteEmployee() {
    const confirmed = window.confirm(
      "Are you sure you want to delete this employee?"
    );

    if (!confirmed) return;

    try {
      await employeesApi.delete(id);
      navigate("/employees");
    } catch (err) {
      setError(err.message);
    }
  }

  if (loading) {
    return <p>Loading employee...</p>;
  }

  if (error && !employee) {
    return <div className="error">{error}</div>;
  }

  return (
    <>
      <div className="page-header">
        <div>
          <h1>
            {employee.first_name} {employee.last_name}
          </h1>

          <p className="muted">{employee.employee_code}</p>
        </div>

        <div className="actions">
          <button
            className="secondary"
            onClick={() => setEditing(!editing)}
          >
            {editing ? "Cancel Edit" : "Edit"}
          </button>

          <button className="danger" onClick={deleteEmployee}>
            Delete
          </button>
        </div>
      </div>

      {error && <div className="error">{error}</div>}

      {editing ? (
        <section className="card">
          <h2>Edit Employee</h2>

          <EmployeeForm
            initialValues={employee}
            onSubmit={updateEmployee}
            onCancel={() => setEditing(false)}
          />
        </section>
      ) : (
        <section className="card employee-info">
          <div>
            <strong>Email</strong>
            <span>{employee.email}</span>
          </div>

          <div>
            <strong>Department</strong>
            <span>{employee.department}</span>
          </div>

          <div>
            <strong>Country</strong>
            <span>{employee.country}</span>
          </div>

          <div>
            <strong>Job Title</strong>
            <span>{employee.job_title}</span>
          </div>

          <div>
            <strong>Joining Date</strong>
            <span>{employee.joining_date}</span>
          </div>
        </section>
      )}

      <section className="card">
        <h2>Add Salary</h2>
        <SalaryForm onSubmit={addSalary} />
      </section>

      <section className="card">
        <h2>Salary History</h2>

        {salaries.length === 0 ? (
          <p>No salary records available.</p>
        ) : (
          <div className="table-wrapper">
            <table>
              <thead>
                <tr>
                  <th>Effective From</th>
                  <th>Base Salary</th>
                  <th>Bonus</th>
                  <th>Currency</th>
                </tr>
              </thead>

              <tbody>
                {salaries.map((salary) => (
                  <tr key={salary.id}>
                    <td>{salary.effective_from}</td>
                    <td>{salary.base_salary}</td>
                    <td>{salary.bonus}</td>
                    <td>{salary.currency}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </>
  );
}