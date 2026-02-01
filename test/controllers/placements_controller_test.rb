require "test_helper"

class PlacementsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get placements_new_url
    assert_response :success
  end

  test "should get create" do
    get placements_create_url
    assert_response :success
  end

  test "should get destroy" do
    get placements_destroy_url
    assert_response :success
  end
end
