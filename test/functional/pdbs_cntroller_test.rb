require 'test_helper'

class PdbsControllerTest < ActionController::TestCase
  setup do
    @pdb = pdbs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pdbs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pdb" do
    assert_difference('Pdb.count') do
      post :create, pdb: { description: @pdb.description, id: @pdb.id }
    end

    assert_redirected_to pdb_path(assigns(:pdb))
  end

  test "should show pdb" do
    get :show, id: @pdb
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pdb
    assert_response :success
  end

  test "should update pdb" do
    put :update, id: @pdb, pdb: { description: @pdb.description, id: @pdb.id }
    assert_redirected_to pdb_path(assigns(:pdb))
  end

  test "should destroy pdb" do
    assert_difference('Pdb.count', -1) do
      delete :destroy, id: @pdb
    end

    assert_redirected_to pdbs_path
  end
end
