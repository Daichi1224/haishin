require "test_helper"

class VehicleAssignmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get vehicle_assignments_create_url
    assert_response :success
  end

  test "should get destroy" do
    get vehicle_assignments_destroy_url
    assert_response :success
  end
end
