require "test_helper"

class EmployeeQueryTest < ActiveSupport::TestCase
  setup do
    @john = employees(:john)
    @jane = employees(:jane)
  end

  test "searches by first name" do
    result = EmployeeQuery.new(
      Employee.all,
      search: "John"
    ).call

    assert_includes result, @john
    assert_not_includes result, @jane
  end

  test "search is case insensitive" do
    result = EmployeeQuery.new(
      Employee.all,
      search: "john"
    ).call

    assert_includes result, @john
  end

  test "searches by employee code" do
    result = EmployeeQuery.new(
      Employee.all,
      search: @john.employee_code
    ).call

    assert_includes result, @john
  end

  test "filters by department" do
    result = EmployeeQuery.new(
      Employee.all,
      department: "Engineering"
    ).call

    assert_includes result, @john
    assert_not_includes result, @jane
  end

  test "filters by country" do
    result = EmployeeQuery.new(
      Employee.all,
      country: "India"
    ).call

    assert_includes result, @jane
    assert_not_includes result, @john
  end

  test "combines multiple filters" do
    result = EmployeeQuery.new(
      Employee.all,
      department: "Engineering",
      country: "United States"
    ).call

    assert_includes result, @john
    assert_not_includes result, @jane
  end

  test "sorts employees by first name ascending" do
    result = EmployeeQuery.new(
      Employee.all,
      sort: "first_name",
      direction: "asc"
    ).call.to_a

    assert_equal result.sort_by(&:first_name), result
  end

  test "uses safe default sorting for invalid sort column" do
    result = EmployeeQuery.new(
      Employee.all,
      sort: "something_invalid",
      direction: "asc"
    ).call

    assert result.to_sql.include?("created_at")
  end
end