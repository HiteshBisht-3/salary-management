const API_URL =
  import.meta.env.VITE_API_URL || "http://localhost:3000/api/v1";

async function request(path, options = {}) {
  const response = await fetch(`${API_URL}${path}`, {
    headers: {
      "Content-Type": "application/json",
      ...options.headers,
    },
    ...options,
  });

  if (response.status === 204) {
    return null;
  }

  const data = await response.json();

  if (!response.ok) {
    throw new Error(
      data.errors?.join(", ") ||
        data.error ||
        "Something went wrong"
    );
  }

  return data;
}

export const employeesApi = {
  list(params = {}) {
    const query = new URLSearchParams();

    Object.entries(params).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== "") {
        query.set(key, value);
      }
    });

    return request(`/employees?${query}`);
  },

  get(id) {
    return request(`/employees/${id}`);
  },

  create(employee) {
    return request("/employees", {
      method: "POST",
      body: JSON.stringify({ employee }),
    });
  },

  update(id, employee) {
    return request(`/employees/${id}`, {
      method: "PATCH",
      body: JSON.stringify({ employee }),
    });
  },

  delete(id) {
    return request(`/employees/${id}`, {
      method: "DELETE",
    });
  },

  salaries(id) {
    return request(`/employees/${id}/salaries`);
  },

  addSalary(id, salary) {
    return request(`/employees/${id}/salaries`, {
      method: "POST",
      body: JSON.stringify({ salary }),
    });
  },
};

export const analyticsApi = {
  summary() {
    return request("/analytics/summary");
  },

  byDepartment() {
    return request("/analytics/by_department");
  },

  byCountry() {
    return request("/analytics/by_country");
  },
};