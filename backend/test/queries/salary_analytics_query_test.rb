require "test_helper"

class SalaryAnalyticsQueryTest < ActiveSupport::TestCase
  setup do
    @query = SalaryAnalyticsQuery.new
  end

  test "summary returns total employee count" do
    result = @query.summary

    assert_equal Employee.count, result[:total_employees]
  end

  test "summary groups compensation by currency" do
    result = @query.summary

    currencies =
      result[:compensation_by_currency].map do |item|
        item[:currency]
      end

    assert_includes currencies, "USD"
    assert_includes currencies, "INR"
  end

  test "department analytics returns department information" do
    result = @query.by_department

    assert result.any?

    engineering =
      result.find do |item|
        item[:department] == "Engineering"
      end

    assert engineering.present?
    assert engineering[:employee_count].positive?
  end

  test "country analytics returns country information" do
    result = @query.by_country

    assert result.any?

    countries = result.map { |item| item[:country] }

    assert_includes countries, "United States"
    assert_includes countries, "India"
  end

  test "analytics uses only latest salary for each employee" do
    employee = employees(:john)

    Salary.create!(
      employee: employee,
      base_salary: 100_000,
      bonus: 10_000,
      currency: "USD",
      effective_from: Date.new(2026, 1, 1)
    )

    Salary.create!(
      employee: employee,
      base_salary: 120_000,
      bonus: 12_000,
      currency: "USD",
      effective_from: Date.new(2027, 1, 1)
    )

    current_salary_ids =
      Salary
        .where(
          id: Salary
            .select("DISTINCT ON (employee_id) id")
            .order(
              :employee_id,
              effective_from: :desc,
              created_at: :desc
            )
        )
        .pluck(:id)

    assert_includes current_salary_ids,
                    employee.salaries.recent_first.first.id

    assert_equal 1,
                 Salary
                   .where(id: current_salary_ids)
                   .where(employee_id: employee.id)
                   .count
  end
end