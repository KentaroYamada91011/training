require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @task = tasks(:one)
  end

  test "should get new" do
    get tasks_new_url
    assert_response :success
  end

  test "should get edit" do
    get tasks_edit_url(@task)
    assert_response :success
  end

  test "should get show" do
    get tasks_show_url(@task)
    assert_response :success
  end

  test "should get index" do
    get tasks_url
    assert_response :success
  end

end