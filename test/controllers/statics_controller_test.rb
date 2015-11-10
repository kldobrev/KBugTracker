require 'test_helper'

class StaticsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get guide" do
    get :guide
    assert_response :success
  end

  test "should get reccomendations" do
    get :reccomendations
    assert_response :success
  end

  test "should get application" do
    get :application
    assert_response :success
  end

end
