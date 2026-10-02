require "test_helper"

class Api::V1::AnalyticsTest < ActionDispatch::IntegrationTest
  test "returns salary summary" do
    get "/api/v1/analytics/summary"

    assert_response :success

    body = JSON.parse(response.body)

    assert body.key?("total_employees")
    assert body.key?("compensation_by_currency")

    assert_kind_of Array,
                   body["compensation_by_currency"]
  end

  test "returns analytics by department" do
    get "/api/v1/analytics/by_department"

    assert_response :success

    body = JSON.parse(response.body)

    assert_kind_of Array, body
    assert body.any? do |item|
      item["department"] == "Engineering"
    end
  end

  test "returns analytics by country" do
    get "/api/v1/analytics/by_country"

    assert_response :success

    body = JSON.parse(response.body)

    assert_kind_of Array, body
    assert body.any? do |item|
      item["country"] == "United States"
    end
  end
end