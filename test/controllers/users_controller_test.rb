# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @hal = users(:Hal)
    @brad = users(:Brad)
    sign_in(@hal)
  end

  test 'login redirect' do
    sign_out(@hal)
    get :index
    assert_redirected_to new_user_session_path
  end

  test 'admin only access' do
    sign_out(@hal)
    sign_in(@brad)
    get :index
    assert_response 302
  end

  test 'index' do
    get :index
    assert_response 200

    assert_match(/Brad/, response.body)
    assert_match(/Hal/, response.body)
  end

  test 'show' do
    get :show, id: @brad.id
    assert_response 200

    assert_match(/Brad Jezek/, response.body)
    assert_match(/brad@yahoo.com/, response.body)
    assert_match(/2016-01/, response.body) # Simple walk calculation test
    assert_match(/2016-01-01/, response.body)
    assert_match(/2016-01-15/, response.body)
    assert_match(/90 min/, response.body)
    assert_match(/60 min/, response.body)
  end

  test 'new' do
    get :new
    assert_response 200
  end

  test 'edit' do
    get :edit, id: @brad.id
    assert_response 200

    assert_select 'form'
    assert_select 'input#user_name', value: 'Brad Jezek'
    assert_select 'input#user_email', value: 'brad@yahoo.com'
  end

  test 'create' do
    assert_difference('User.count', 1) do
      post :create, user: { name: 'Clint Troxel', email: 'clint@ctro.net',
                            password: 'shhhshhh',
                            password_confirmation: 'shhhshhh' }
    end

    user = assigns(:user)
    assert_redirected_to user_path(user)
    assert user.is_a?(User)
    assert user.created_at
    assert_match(/success/, flash[:notice])
  end

  test 'failed create' do
    assert_difference('User.count', 0) do
      post :create, user: { name: '', email: '', address: '' }
    end

    assert_match(/error/, response.body)
    assert_match(/be blank/, response.body)
  end

  test 'update' do
    put :update, id: @brad.id, user: { name: 'Bradley' }
    assert_redirected_to user_url(@brad)
    assert_match('Bradley', assigns(:user).name)
    assert_match(/success/, flash[:notice])
  end

  test 'failed update' do
    put :update, id: @brad.id, user: { name: '' }
    assert_match(/error/, response.body)
    assert_match(/be blank/, response.body)
  end

  test 'destroy' do
    assert_difference('User.count', -1) do
      delete :destroy, id: @brad.id
    end
    assert_redirected_to users_path
  end

  test 'change password' do
    put :update, id: @brad.id, user: { name: 'Bradley', password: 'shhh',
                                       password_confirmation: '' }
    assert_match(/is too short/, assigns(:user).errors.messages.to_s)
    assert_match(/doesn't match Password/, assigns(:user).errors.messages.to_s)

    put :update, id: @brad.id, user: { name: 'Bradley', password: 'shhhshhh',
                                       password_confirmation: 'shhhshhh' }
    assert_redirected_to user_url(@brad)
    assert_match('Bradley', assigns(:user).name)
    assert_match(/success/, flash[:notice])
  end
end
