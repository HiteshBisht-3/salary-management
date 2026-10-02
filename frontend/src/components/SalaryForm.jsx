import { useState } from "react";

export default function SalaryForm({ onSubmit }) {
  const [form, setForm] = useState({
    base_salary: "",
    bonus: "0",
    currency: "",
    effective_from: "",
  });

  const [saving, setSaving] = useState(false);

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

      setForm({
        base_salary: "",
        bonus: "0",
        currency: "",
        effective_from: "",
      });
    } finally {
      setSaving(false);
    }
  }

  return (
    <form className="form-grid" onSubmit={submit}>
      <input
        name="base_salary"
        type="number"
        min="0"
        step="0.01"
        placeholder="Base Salary"
        value={form.base_salary}
        onChange={change}
        required
      />

      <input
        name="bonus"
        type="number"
        min="0"
        step="0.01"
        placeholder="Bonus"
        value={form.bonus}
        onChange={change}
        required
      />

      <input
        name="currency"
        maxLength="3"
        placeholder="Currency (USD)"
        value={form.currency}
        onChange={change}
        required
      />

      <input
        name="effective_from"
        type="date"
        value={form.effective_from}
        onChange={change}
        required
      />

      <button type="submit" disabled={saving}>
        {saving ? "Adding..." : "Add Salary"}
      </button>
    </form>
  );
}