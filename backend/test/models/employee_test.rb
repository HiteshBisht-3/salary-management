require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  def valid_employee
    Employee.new(
      employee_code: "EMP001",
      first_name: "John",
      last_name: "Smith",
      email: "john.smith@example.com",
      country: "United States",
      department: "Engineering",
      job_title: "Software Engineer",
      joining_date: Date.new(2025, 1, 15)
    )
  end

  test "is valid with valid attributes" do
    employee = valid_employee

    assert employee.valid?
  end

  test "requires employee code" do
    employee = valid_employee
    employee.employee_code = nil

    assert_not employee.valid?
    assert_includes employee.errors[:employee_code], "can't be blank"
  end

  test "requires first name" do
    employee = valid_employee
    employee.first_name = nil

    assert_not employee.valid?
  end

  test "requires last name" do
    employee = valid_employee
    employee.last_name = nil

    assert_not employee.valid?
  end

  test "requires valid email" do
    employee = valid_employee
    employee.email = "invalid-email"

    assert_not employee.valid?
    assert_includes employee.errors[:email], "must be a valid email address"
  end

  test "employee code must be unique" do
    valid_employee.save!

    duplicate = valid_employee
    duplicate.email = "different@example.com"

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:employee_code], "has already been taken"
  end

  test "email must be unique" do
    valid_employee.save!

    duplicate = valid_employee
    duplicate.employee_code = "EMP002"

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "normalizes email before validation" do
    employee = valid_employee
    employee.email = "  JOHN.SMITH@EXAMPLE.COM  "

    employee.valid?

    assert_equal "john.smith@example.com", employee.email
  end

  test "normalizes employee code before validation" do
    employee = valid_employee
    employee.employee_code = "  emp001  "

    employee.valid?

    assert_equal "EMP001", employee.employee_code
  end
end