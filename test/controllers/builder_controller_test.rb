require "test_helper"

class BuilderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get builder_index_url
    assert_response :success
  end
end
