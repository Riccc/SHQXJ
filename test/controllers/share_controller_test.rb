require "test_helper"

class ShareControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get share_show_url
    assert_response :success
  end
end
