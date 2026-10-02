require "test_helper"

class Api::V1::EmployeesTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:john)
  end

  test "returns all employees" do
    get "/api/v1/employees"

    assert_response :success

    body = JSON.parse(response.body)

    assert_kind_of Array, body
    assert body.any? { |employee| employee["id"] == @employee.id }
  end

  test "returns a single employee" do
    get "/api/v1/employees/#{@employee.id}"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal @employee.id, body["id"]
    assert_equal "EMP10001", body["employee_code"]
  end

  test "returns 404 when employee does not exist" do
    get "/api/v1/employees/999999"

    assert_response :not_found

    body = JSON.parse(response.body)

    assert_equal "Resource not found", body["error"]
  end

  test "creates an employee" do
    assert_difference("Employee.count", 1) do
      post "/api/v1/employees",
           params: {
             employee: {
               employee_code: "EMP20001",
               first_name: "Alice",
               last_name: "Johnson",
               email: "alice@example.com",
               country: "United States",
               department: "Engineering",
               job_title: "Backend Engineer",
               joining_date: "2026-01-10"
             }
           },
           as: :json
    end

    assert_response :created

    body = JSON.parse(response.body)

    assert_equal "EMP20001", body["employee_code"]
    assert_equal "Alice", body["first_name"]
  end

  test "does not create employee with invalid data" do
    assert_no_difference("Employee.count") do
      post "/api/v1/employees",
           params: {
             employee: {
               employee_code: "",
               first_name: "",
               email: "invalid-email"
             }
           },
           as: :json
    end

    assert_response :unprocessable_entity

    body = JSON.parse(response.body)

    assert body["errors"].present?
  end

  test "updates an employee" do
    patch "/api/v1/employees/#{@employee.id}",
          params: {
            employee: {
              job_title: "Senior Software Engineer"
            }
          },
          as: :json

    assert_response :success

    @employee.reload

    assert_equal "Senior Software Engineer", @employee.job_title
  end

  test "deletes an employee" do
    assert_difference("Employee.count", -1) do
      delete "/api/v1/employees/#{@employee.id}"
    end

    assert_response :no_content
  end
end