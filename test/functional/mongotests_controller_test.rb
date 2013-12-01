require 'test_helper'

class MongotestsControllerTest < ActionController::TestCase
  setup do
    @mongotest = mongotests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mongotests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mongotest" do
    assert_difference('Mongotest.count') do
      post :create, mongotest: @mongotest.attributes
    end

    assert_redirected_to mongotest_path(assigns(:mongotest))
  end

  test "should show mongotest" do
    get :show, id: @mongotest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mongotest
    assert_response :success
  end

  test "should update mongotest" do
    put :update, id: @mongotest, mongotest: @mongotest.attributes
    assert_redirected_to mongotest_path(assigns(:mongotest))
  end

  test "should destroy mongotest" do
    assert_difference('Mongotest.count', -1) do
      delete :destroy, id: @mongotest
    end

    assert_redirected_to mongotests_path
  end
end
