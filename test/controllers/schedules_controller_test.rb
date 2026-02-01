require "test_helper"

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get schedules_update_url
    assert_response :success
  end
end
