require 'test_helper'

class UeditorResourcesControllerTest < ActionDispatch::IntegrationTest
  test "should get handle_file" do
    get ueditor_resources_handle_file_url
    assert_response :success
  end

end
