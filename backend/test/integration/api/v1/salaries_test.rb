require "test_helper"

class Api::V1::SalariesTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:john)
  end

  test "returns employee salary history" do
    get "/api/v1/employees/#{@employee.id}/salaries"

    assert_response :success

    body = JSON.parse(response.body)

    assert_kind_of Array, body
  end

  test "creates salary for employee" do
    assert_difference("Salary.count", 1) do
      post "/api/v1/employees/#{@employee.id}/salaries",
           params: {
             salary: {
               base_salary: 95_000,
               bonus: 10_000,
               currency: "usd",
               effective_from: "2026-01-01"
             }
           },
           as: :json
    end

    assert_response :created

    body = JSON.parse(response.body)

    assert_equal "USD", body["currency"]
    assert_equal @employee.id, body["employee_id"]
  end

  test "does not create invalid salary" do
    assert_no_difference("Salary.count") do
      post "/api/v1/employees/#{@employee.id}/salaries",
           params: {
             salary: {
               base_salary: -100,
               bonus: 0,
               currency: "USD",
               effective_from: "2026-01-01"
             }
           },
           as: :json
    end

    assert_response :unprocessable_entity

    body = JSON.parse(response.body)

    assert body["errors"].present?
  end

  test "returns 404 for unknown employee" do
    get "/api/v1/employees/999999/salaries"

    assert_response :not_found

    body = JSON.parse(response.body)

    assert_equal "Resource not found", body["error"]
  end
end