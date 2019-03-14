require 'test_helper'

class DogsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @stella = dogs(:Stella)
    @lanie = dogs(:Lanie)
    @grace = dogs(:Grace)
    @steph = clients(:Steph)
    @hal = users(:Hal)
    sign_in(@hal)
  end

  test 'admin only access' do
    sign_out(@hal)
    sign_in(users(:Brad))
    get :index, client_id: @steph.id
    assert_response 302
  end

  # index isn't really in the UI atm...
  test 'index' do
    get :index, client_id: @steph.id
    assert_response :success

    assert_match(/Stella/, response.body)
    assert_match(/Lanie/, response.body)
    assert_match(/Grace/, response.body)
    assert_match(/New Dog/, response.body)
  end

  test 'checkboxes' do
    get :checkboxes, client_id: @steph.id
    assert_response :success
    assert_select 'input', type: 'checkbox' do |cb|
      assert_equal 3, cb.count
    end

    assert_match(/Stella/, response.body)
    assert_match(/Lanie/, response.body)
    assert_match(/Grace/, response.body)
  end

  test 'show' do
    get :show, client_id: @steph.id, id: @stella.id
    assert_response 200

    assert_match(/Stella/, response.body)
    assert_match(/Edit/, response.body)
    assert_match(/Destroy/, response.body)
    assert_match(/Back/, response.body)
    refute_match(/Lanie/, response.body)
  end

  test 'new' do
    get :new, client_id: @steph.id
    assert_response 200
  end

  test 'edit' do
    get :edit, client_id: @steph.id, id: @stella.id
    assert_response 200

    assert_select 'form'
    assert_select 'input#dog_name', value: @stella.name
  end

  test 'create' do
    assert_difference('Dog.count', 1) do
      post :create, client_id: @steph.id, dog: { name: 'Niko' }
    end

    dog = assigns(:dog)
    assert_redirected_to client_path(@steph)
    assert dog.is_a?(Dog)
    assert dog.created_at
    assert_match(/success/, flash[:notice])
  end

  test 'failed create' do
    assert_difference('Dog.count', 0) do
      post :create, client_id: @steph.id, dog: { name: '' }
    end
    assert_response 200
    assert_match(/error/, response.body)
    assert_match(/be blank/, response.body)
  end

  test 'update' do
    new_name = 'Leñas'
    put :update, client_id: @steph.id, id: @lanie.id, dog: { name: new_name }
    assert_redirected_to client_url(@steph)
    assert_match new_name, assigns(:dog).name
    assert_match(/success/, flash[:notice])
  end

  test 'failed update' do
    put :update, client_id: @steph.id, id: @grace.id, dog: { name: '' }
    assert_response 200
    assert_match(/error/, response.body)
    assert_match(/be blank/, response.body)
  end

  test 'destroy' do
    assert_difference('Dog.count', -1) do
      delete :destroy, client_id: @steph.id, id: @lanie.id
    end
    assert_redirected_to client_path(@steph)
  end
end
