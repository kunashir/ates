require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tasks_index_url
    assert_response :success
  end

  test "should get new" do
    get tasks_new_url
    assert_response :success
  end

  test "should get create" do
    get tasks_create_url
    assert_response :success
  end

  test "should get index" do
    get tasks_index_url
    assert_response :success
  end

  test "should get suffle" do
    get tasks_suffle_url
    assert_response :success
  end

  test "should get close" do
    get tasks_close_url
    assert_response :success
  end
end
