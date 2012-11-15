require 'test_helper'

class DataControllerTest < ActionController::TestCase
  setup do
  end

  test "should create datum" do
    assert_difference('Datum.count') do
      post :create, datum: {  }
    end

    assert_redirected_to datum_path(assigns(:datum))
  end

  test "should show datum" do
    get :show, id: @datum
    assert_response :success
  end
end
