require 'test_helper'

class ProteinsControllerTest < ActionController::TestCase
  setup do
    @protein = proteins(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proteins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create protein" do
    assert_difference('Protein.count') do
      post :create, protein: { description: @protein.description, id: @protein.id }
    end

    assert_redirected_to protein_path(assigns(:protein))
  end

  test "should show protein" do
    get :show, id: @protein
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @protein
    assert_response :success
  end

  test "should update protein" do
    put :update, id: @protein, protein: { description: @protein.description, id: @protein.id }
    assert_redirected_to protein_path(assigns(:protein))
  end

  test "should destroy protein" do
    assert_difference('Protein.count', -1) do
      delete :destroy, id: @protein
    end

    assert_redirected_to proteins_path
  end
end
