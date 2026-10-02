require "test_helper"

class SalaryTest < ActiveSupport::TestCase
  setup do
    @employee = employees(:john)
  end

  def valid_salary
    Salary.new(
      employee: @employee,
      base_salary: 75_000,
      bonus: 5_000,
      currency: "USD",
      effective_from: Date.new(2026, 1, 1)
    )
  end

  test "is valid with valid attributes" do
    assert valid_salary.valid?
  end

  test "requires an employee" do
    salary = valid_salary
    salary.employee = nil

    assert_not salary.valid?
  end

  test "requires base salary" do
    salary = valid_salary
    salary.base_salary = nil

    assert_not salary.valid?
  end

  test "base salary cannot be negative" do
    salary = valid_salary
    salary.base_salary = -1

    assert_not salary.valid?
  end

  test "bonus cannot be negative" do
    salary = valid_salary
    salary.bonus = -1

    assert_not salary.valid?
  end

  test "requires currency" do
    salary = valid_salary
    salary.currency = nil

    assert_not salary.valid?
  end

  test "currency must contain three characters" do
    salary = valid_salary
    salary.currency = "US"

    assert_not salary.valid?
  end

  test "normalizes currency to uppercase" do
    salary = valid_salary
    salary.currency = " usd "

    salary.valid?

    assert_equal "USD", salary.currency
  end

  test "requires effective date" do
    salary = valid_salary
    salary.effective_from = nil

    assert_not salary.valid?
  end

  test "recent first returns newest salary first" do
    older = Salary.create!(
      employee: @employee,
      base_salary: 70_000,
      bonus: 5_000,
      currency: "USD",
      effective_from: Date.new(2024, 1, 1)
    )

    newer = Salary.create!(
      employee: @employee,
      base_salary: 90_000,
      bonus: 8_000,
      currency: "USD",
      effective_from: Date.new(2026, 1, 1)
    )

    salaries = @employee.salaries.recent_first

    assert_operator salaries.index(newer), :<, salaries.index(older)
  end
end