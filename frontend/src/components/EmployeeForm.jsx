import { useEffect, useState } from "react";

const emptyEmployee = {
  employee_code: "",
  first_name: "",
  last_name: "",
  email: "",
  country: "",
  department: "",
  job_title: "",
  joining_date: "",
};

export default function EmployeeForm({
  initialValues,
  onSubmit,
  onCancel,
}) {
  const [form, setForm] = useState(emptyEmployee);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    setForm(initialValues || emptyEmployee);
  }, [initialValues]);

  function change(event) {
    setForm({
      ...form,
      [event.target.name]: event.target.value,
    });
  }

  async function submit(event) {
    event.preventDefault();

    try {
      setSaving(true);
      await onSubmit(form);
    } finally {
      setSaving(false);
    }
  }

  return (
    <form className="form-grid" onSubmit={submit}>
      <input
        name="employee_code"
        placeholder="Employee Code"
        value={form.employee_code}
        onChange={change}
        required
      />

      <input
        name="first_name"
        placeholder="First Name"
        value={form.first_name}
        onChange={change}
        required
      />

      <input
        name="last_name"
        placeholder="Last Name"
        value={form.last_name}
        onChange={change}
        required
      />

      <input
        name="email"
        type="email"
        placeholder="Email"
        value={form.email}
        onChange={change}
        required
      />

      <input
        name="country"
        placeholder="Country"
        value={form.country}
        onChange={change}
        required
      />

      <input
        name="department"
        placeholder="Department"
        value={form.department}
        onChange={change}
        required
      />

      <input
        name="job_title"
        placeholder="Job Title"
        value={form.job_title}
        onChange={change}
        required
      />

      <input
        name="joining_date"
        type="date"
        value={form.joining_date}
        onChange={change}
        required
      />

      <div className="form-actions">
        <button type="submit" disabled={saving}>
          {saving ? "Saving..." : "Save"}
        </button>

        {onCancel && (
          <button type="button" className="secondary" onClick={onCancel}>
            Cancel
          </button>
        )}
      </div>
    </form>
  );
}