require "test_helper"

class YoutubeControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get youtube_new_url
    assert_response :success
  end

  test "should get create" do
    get youtube_create_url
    assert_response :success
  end
end
