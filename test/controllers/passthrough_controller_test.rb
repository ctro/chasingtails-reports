require 'test_helper'

class PassthroughControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  # Passthrough Controller happens after login.
  #  normal users go to new reports#new
  #  admins go to reports#index

  test "passthrough as normal user" do
    sign_in(users(:Brad))
    get :index
    assert_redirected_to new_report_path()
  end

  test "passthrough as admin" do
    sign_in(users(:Hal))
    get :index
    assert_redirected_to reports_path()
  end
end
