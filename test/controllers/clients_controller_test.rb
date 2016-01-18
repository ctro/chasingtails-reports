require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @hal = users(:Hal)
    @brad = users(:Brad)
    @morris = clients(:Morris)
    sign_in(@hal)
  end

  test "admin only access" do
    sign_out(@hal)
    sign_in(@brad)
    get :index
    assert_response 302
  end

  test "get index while logged in and not" do
    sign_out(@hal)
    get :index
    assert_response 302

    sign_in(@hal)
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)

    sign_out(@hal)
    get :index
    assert_response 302
  end

  test "non admin user cannot access" do
    sign_in(@brad)
    get :index
    assert_response 302
  end

  test "clients are present on index" do
    get :index

    assert_match /Stephanie &amp; Clay<\/a>/, response.body    # Should be a link to Client
    assert_match /mailto:steph@email.com/, response.body       # Should be a link that opens an email
    assert_match /Rancher and Hansen/, response.body
    assert_match /Stella<\/a>/, response.body                  # Should be a link to each dog
    assert_match /Lanie<\/a>/, response.body
    assert_match /Grace<\/a>/, response.body

    assert_match /Morris/, response.body
    assert_match /mailto:morris@gmail.com/, response.body
    assert_match /Hansen Alley/, response.body
    assert_match /PussyJamboree<\/a>/, response.body
  end

  # Some tests require that the fixture have an ID.
  #   having an ID breaks the fancy relationships.
  # Hence, 2 sets of fixture data 1 with ids, 1 without
  test "show" do
    client = clients(:ClientWithID)
    get :show, id: client
    assert_response :success

    assert_match client.name, response.body
    assert_match client.email, response.body
    assert_match client.address, response.body
    assert_match /IDDOG/, response.body  # 2 dogs displayed
    assert_match /IDDOG2/, response.body

    # Walks should be shown
    assert_match /2016-01-01/, response.body
    assert_match /2016-01-15/, response.body
    assert_match /09:00 am/, response.body
    assert_match /60 min/, response.body
    assert_match /3.25 hours/, response.body # Month total from reports.yml
    assert_match /January/, response.body # Month total
  end

  test "new" do
    get :new
    assert_response 200
  end

  test "edit" do
    get :edit, :id => @morris.id
    assert_response 200

    assert_select "form"
    assert_select "input#client_name", value: @morris.name
  end

  test "create" do
    assert_difference('Client.count', 1) do
      post :create, client: {name: "Clint Troxel", email: "clint@ctro.net", address: "box 2101 83001"}
    end

    client = assigns(:client)
    assert_redirected_to client_path(client)
    assert client.is_a?(Client)
    assert client.created_at
    assert_match /success/, flash[:notice]
  end

  test "failed create" do
    assert_difference('Client.count', 0) do
      post :create, client: {name: "", email: "", address: ""}
    end

    assert_match /error/, response.body
    assert_match /be blank/, response.body
  end

  test "update" do
    newAddress = "In a van down by the river"
    put :update, id: @morris.id, client: {address: newAddress}
    assert_redirected_to client_url(@morris)
    assert_match newAddress, assigns(:client).address
    assert_match /success/, flash[:notice]
  end

  test "failed update" do
    put :update, id: @morris.id, client: {name: ""}
    assert_match /error/, response.body
    assert_match /be blank/, response.body
  end

  test "destroy" do
    assert_difference('Client.count', -1) do
      delete :destroy, :id => @morris.id
    end
    assert_redirected_to clients_path
  end

end
