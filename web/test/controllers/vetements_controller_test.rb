require 'test_helper'

class VetementsControllerTest < ActionController::TestCase
  setup do
    @vetement = vetements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vetements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vetement" do
    assert_difference('Vetement.count') do
      post :create, vetement: {  }
    end

    assert_redirected_to vetement_path(assigns(:vetement))
  end

  test "should show vetement" do
    get :show, id: @vetement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vetement
    assert_response :success
  end

  test "should update vetement" do
    patch :update, id: @vetement, vetement: {  }
    assert_redirected_to vetement_path(assigns(:vetement))
  end

  test "should destroy vetement" do
    assert_difference('Vetement.count', -1) do
      delete :destroy, id: @vetement
    end

    assert_redirected_to vetements_path
  end
end
