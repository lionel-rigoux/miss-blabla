require 'test_helper'

class QuantitesControllerTest < ActionController::TestCase
  setup do
    @quantite = quantites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quantites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quantite" do
    assert_difference('Quantite.count') do
      post :create, quantite: {  }
    end

    assert_redirected_to quantite_path(assigns(:quantite))
  end

  test "should show quantite" do
    get :show, id: @quantite
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quantite
    assert_response :success
  end

  test "should update quantite" do
    patch :update, id: @quantite, quantite: {  }
    assert_redirected_to quantite_path(assigns(:quantite))
  end

  test "should destroy quantite" do
    assert_difference('Quantite.count', -1) do
      delete :destroy, id: @quantite
    end

    assert_redirected_to quantites_path
  end
end
