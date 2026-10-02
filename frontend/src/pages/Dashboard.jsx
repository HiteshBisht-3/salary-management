import { useEffect, useState } from "react";
import { analyticsApi } from "../api/api";

export default function Dashboard() {
  const [summary, setSummary] = useState(null);
  const [departments, setDepartments] = useState([]);
  const [countries, setCountries] = useState([]);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    async function load() {
      try {
        const [summaryData, departmentData, countryData] =
          await Promise.all([
            analyticsApi.summary(),
            analyticsApi.byDepartment(),
            analyticsApi.byCountry(),
          ]);

        setSummary(summaryData);
        setDepartments(departmentData);
        setCountries(countryData);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }

    load();
  }, []);

  if (loading) {
    return <p>Loading dashboard...</p>;
  }

  return (
    <>
      <div className="page-header">
        <div>
          <h1>Salary Dashboard</h1>
          <p className="muted">
            Organization compensation overview.
          </p>
        </div>
      </div>

      {error && <div className="error">{error}</div>}

      {summary && (
        <>
          <div className="stats">
            <div className="stat-card">
              <span>Total Employees</span>
              <strong>
                {summary.total_employees.toLocaleString()}
              </strong>
            </div>

            {summary.compensation_by_currency.map((item) => (
              <div
                className="stat-card"
                key={item.currency}
              >
                <span>{item.currency} Employees</span>
                <strong>
                  {item.employee_count.toLocaleString()}
                </strong>

                <small>
                  Avg base salary:{" "}
                  {Number(
                    item.average_base_salary
                  ).toLocaleString()}
                </small>
              </div>
            ))}
          </div>
        </>
      )}

      <section className="card">
        <h2>Compensation by Department</h2>

        <div className="table-wrapper">
          <table>
            <thead>
              <tr>
                <th>Department</th>
                <th>Currency</th>
                <th>Employees</th>
                <th>Average Salary</th>
                <th>Min</th>
                <th>Max</th>
              </tr>
            </thead>

            <tbody>
              {departments.map((item, index) => (
                <tr
                  key={`${item.department}-${item.currency}-${index}`}
                >
                  <td>{item.department}</td>
                  <td>{item.currency}</td>
                  <td>{item.employee_count}</td>
                  <td>{item.average_base_salary}</td>
                  <td>{item.minimum_base_salary}</td>
                  <td>{item.maximum_base_salary}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>

      <section className="card">
        <h2>Compensation by Country</h2>

        <div className="table-wrapper">
          <table>
            <thead>
              <tr>
                <th>Country</th>
                <th>Currency</th>
                <th>Employees</th>
                <th>Average Salary</th>
                <th>Total Base Salary</th>
                <th>Total Bonus</th>
              </tr>
            </thead>

            <tbody>
              {countries.map((item, index) => (
                <tr
                  key={`${item.country}-${item.currency}-${index}`}
                >
                  <td>{item.country}</td>
                  <td>{item.currency}</td>
                  <td>{item.employee_count}</td>
                  <td>{item.average_base_salary}</td>
                  <td>{item.total_base_salary}</td>
                  <td>{item.total_bonus}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </>
  );
}