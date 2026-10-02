class SalaryAnalyticsQuery
  def summary
    {
      total_employees: Employee.count,
      compensation_by_currency: compensation_by_currency
    }
  end

  def by_department
    current_salaries
      .joins(:employee)
      .group("employees.department", :currency)
      .pluck(
        "employees.department",
        :currency,
        Arel.sql("COUNT(*)"),
        Arel.sql("ROUND(AVG(base_salary), 2)"),
        Arel.sql("MIN(base_salary)"),
        Arel.sql("MAX(base_salary)"),
        Arel.sql("SUM(base_salary)"),
        Arel.sql("SUM(bonus)")
      )
      .map do |row|
        {
          department: row[0],
          currency: row[1],
          employee_count: row[2],
          average_base_salary: row[3],
          minimum_base_salary: row[4],
          maximum_base_salary: row[5],
          total_base_salary: row[6],
          total_bonus: row[7]
        }
      end
  end

  def by_country
    current_salaries
      .joins(:employee)
      .group("employees.country", :currency)
      .pluck(
        "employees.country",
        :currency,
        Arel.sql("COUNT(*)"),
        Arel.sql("ROUND(AVG(base_salary), 2)"),
        Arel.sql("MIN(base_salary)"),
        Arel.sql("MAX(base_salary)"),
        Arel.sql("SUM(base_salary)"),
        Arel.sql("SUM(bonus)")
      )
      .map do |row|
        {
          country: row[0],
          currency: row[1],
          employee_count: row[2],
          average_base_salary: row[3],
          minimum_base_salary: row[4],
          maximum_base_salary: row[5],
          total_base_salary: row[6],
          total_bonus: row[7]
        }
      end
  end

  private

  def compensation_by_currency
    current_salaries
      .group(:currency)
      .pluck(
        :currency,
        Arel.sql("COUNT(*)"),
        Arel.sql("ROUND(AVG(base_salary), 2)"),
        Arel.sql("MIN(base_salary)"),
        Arel.sql("MAX(base_salary)"),
        Arel.sql("SUM(base_salary)"),
        Arel.sql("SUM(bonus)")
      )
      .map do |row|
        {
          currency: row[0],
          employee_count: row[1],
          average_base_salary: row[2],
          minimum_base_salary: row[3],
          maximum_base_salary: row[4],
          total_base_salary: row[5],
          total_bonus: row[6]
        }
      end
  end

  def current_salaries
    Salary
      .where(
        id: Salary
          .select("DISTINCT ON (employee_id) id")
          .order(:employee_id, effective_from: :desc, created_at: :desc)
      )
  end
end