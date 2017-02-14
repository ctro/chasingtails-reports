require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @stella = dogs(:Stella)
    @lanie = dogs(:Lanie)
    @grace = dogs(:Grace)
    @steph = clients(:Steph)
    @hal = users(:Hal)

    @report = reports(:StellaLanieGrace)
    # Fixture relationships are broken. :shrug:
    @report.dogs = [dogs(:Stella), dogs(:Lanie), dogs(:Grace)]
    sign_in(@hal)
  end

  test "admin only access" do
    sign_out(@hal)
    sign_in(users(:Brad))
    get :index
    assert_response 302
  end

  test "index" do
    get :index
    assert_response 200

    assert_match /Previous/, response.body
    assert_match /Next/, response.body

    assert_match /January 15, 2016/, response.body
    assert_match /12:00 pm/, response.body
    assert_match /09:00 am/, response.body
    assert_match /Stephanie &amp; Clay/, response.body
    assert_match /Stella/, response.body
    assert_match /Lanie/, response.body
    assert_match /Grace/, response.body

    assert_match /reports\/xxx000xxxoooxxx000xxxx/, response.body # uuid links
  end

  test "show" do
    get :show, id: @report.uuid
    assert_response 200

    assert_select 'h1', /#{@report.dog_names}*/
    assert_select 'p', /Hal Wheeler/
    assert_select 'p', /90 minutes/
    assert_select 'p', /09:00 am/
  end

  test "show without session" do
    sign_out(@hal)
    get :show, id: @report.uuid
    assert_response 200
    assert_select 'h1', /Stella, Lanie, Grace/
  end

  test "new" do
    get :new
    assert_response 200
    assert_select 'input', type: 'file'
  end

  test "edit" do
    get :edit, id: @report.uuid
    assert_response 200

    assert_select 'select#report_client_id', value: @report.client.name
  end

  test "create" do
    assert_difference('Report.count', 1) do
      post :create, report: {
        user_id: users(:Brad).id, client_id: clients(:Steph).id,
        dog_ids: [dogs(:Lanie).id, dogs(:Grace).id],
        walk_date: "2016-01-17", walk_time: "22:00",
        walk_duration: "30", no_show: true }
    end

    report = assigns(:report)
    assert_redirected_to report_path(report)
    assert report.is_a?(Report)
    assert report.created_at
    assert_match /success/, flash[:notice]
  end

  # !!! This test actually uploads a 1x1PNG file to S3/tails-test bucket...
  test "create with image upload" do
    assert_difference('Report.count', 1) do

      post :create, report: {
        user_id: users(:Brad).id, client_id: clients(:Steph).id,
        dog_ids: [dogs(:Lanie).id, dogs(:Grace).id], walk_date: "2016-01-17",
        walk_time: "22:00", walk_duration: "30", weather: "ok", recap: "ok",
        pees: "ok", poops: "ok", energy: "ok", vocalization: "ok", overall: "ok",
        :images_attributes => [
          { asset: fixture_file_upload('files/1x1.png','image/png', true) }
        ]
      }
    end

    report = assigns(:report)
    assert_equal 1, report.images.count
    assert report.save

    get :edit, id: report.uuid
    assert_response 200

    # New image show in edit page
    assert_match /This is saved as/, response.body
    assert_match /Choose again to overwrite/, response.body
  end

  test "image validation" do
    assert_difference('Report.count', 0) do
      post :create, report: {
        user_id: users(:Brad).id, client_id: clients(:Steph).id,
        dog_ids: [dogs(:Lanie).id, dogs(:Grace).id], walk_date: "2016-01-17",
        walk_time: "22:00", walk_duration: "30", weather: "ok", recap: "ok",
        pees: "ok", poops: "ok", energy: "ok", vocalization: "ok", overall: "ok"}
    end

    report = assigns(:report)
    assert_equal 1, report.errors.size
    assert_match /at least one image/, report.errors.first.to_s
  end

  test "failed create" do
    assert_difference('Report.count', 0) do
      post :create, report: { user_id: users(:Brad).id, walk_date: "" }
    end

    assert_match /error/, response.body
    assert_match /be blank/, response.body
  end

  test "update" do
    put :update, id: @report.uuid, report: {no_show: true}
    assert_redirected_to report_url(@report)
    assert assigns(:report).no_show
    assert_match /success/, flash[:notice]
  end

  test "failed update" do
    put :update, id: @report.uuid, report: {walk_date: ""}
    assert_match /error/, response.body
    assert_match /be blank/, response.body
  end

  test "destroy" do
    assert_difference('Report.count', -1) do
      delete :destroy, :id => @report.uuid
    end
    assert_redirected_to reports_path
  end

end
