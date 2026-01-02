require File.expand_path('../../test_helper', __FILE__)

class EasyLoginControllerTest < ActionController::TestCase
  fixtures :users, :email_addresses

  def setup
    @request = ActionController::TestRequest.create(self.class.controller_class)
    @response = ActionController::TestResponse.new
  end

  test "should redirect to home with error when user not found in development" do
    Rails.env.stubs(:development?).returns(true)
    Rails.env.stubs(:staging?).returns(false)
    
    post :try_to_login, params: { user_id: 99999 }
    
    assert_redirected_to home_url
    assert_equal I18n.t(:user_not_found), flash[:error]
  end

  test "should redirect to home with error when user not found in staging" do
    Rails.env.stubs(:development?).returns(false)
    Rails.env.stubs(:staging?).returns(true)
    
    post :try_to_login, params: { user_id: 99999 }
    
    assert_redirected_to home_url
    assert_equal I18n.t(:user_not_found), flash[:error]
  end

  test "should successfully authenticate active user" do
    user = User.find(2) # Assuming user with id 2 is active
    user.update_attribute(:status, User::STATUS_ACTIVE)
    
    Rails.env.stubs(:development?).returns(true)
    
    post :try_to_login, params: { user_id: user.id }
    
    assert_response :redirect
    assert_equal user.id, User.current.id
  end

  test "should not authenticate inactive user" do
    user = User.find(2)
    user.update_attribute(:status, User::STATUS_LOCKED)
    
    Rails.env.stubs(:development?).returns(true)
    
    post :try_to_login, params: { user_id: user.id }
    
    # User should not be logged in
    assert_not_equal user.id, User.current.id
  end

  test "should handle blank user_id parameter" do
    Rails.env.stubs(:development?).returns(true)
    
    post :try_to_login, params: { user_id: nil }
    
    assert_redirected_to home_url
    assert_equal I18n.t(:user_not_found), flash[:error]
  end

  test "should not work in production environment" do
    Rails.env.stubs(:development?).returns(false)
    Rails.env.stubs(:staging?).returns(false)
    Rails.env.stubs(:production?).returns(true)
    
    user = User.find(2)
    user.update_attribute(:status, User::STATUS_ACTIVE)
    
    post :try_to_login, params: { user_id: user.id }
    
    # In production, blank user should be nil and no redirect happens
    # The controller should not perform authentication
    assert_response :success
  end
end
