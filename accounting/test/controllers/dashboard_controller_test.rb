require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get main" do
    get dashboard_main_url
    assert_response :success
  end

  test "should get popug" do
    get dashboard_popug_url
    assert_response :success
  end

  test "should get manager" do
    get dashboard_manager_url
    assert_response :success
  end
end
