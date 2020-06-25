require 'test_helper'

class WorkLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @work_log = work_logs(:one)
  end

  test "should get index" do
    get work_logs_url, as: :json
    assert_response :success
  end

  test "should create work_log" do
    assert_difference('WorkLog.count') do
      post work_logs_url, params: { work_log: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show work_log" do
    get work_log_url(@work_log), as: :json
    assert_response :success
  end

  test "should update work_log" do
    patch work_log_url(@work_log), params: { work_log: {  } }, as: :json
    assert_response 200
  end

  test "should destroy work_log" do
    assert_difference('WorkLog.count', -1) do
      delete work_log_url(@work_log), as: :json
    end

    assert_response 204
  end
end
