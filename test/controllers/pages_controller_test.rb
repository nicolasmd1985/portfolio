require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_url
    assert_response :success
  end

  test "should get about" do
    get about_url
    assert_response :success
  end

  test "should get projects" do
    get projects_url
    assert_response :success
  end

  test "should get services" do
    get services_url
    assert_response :success
  end

  test "should get contact" do
    get contact_url
    assert_response :success
  end
end
