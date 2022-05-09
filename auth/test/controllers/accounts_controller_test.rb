require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get accounts_index_url
    assert_response :success
  end

  test "should get current" do
    get accounts_current_url
    assert_response :success
  end

  test "should get edit" do
    get accounts_edit_url
    assert_response :success
  end

  test "should get update" do
    get accounts_update_url
    assert_response :success
  end

  test "should get destroy" do
    get accounts_destroy_url
    assert_response :success
  end
end
