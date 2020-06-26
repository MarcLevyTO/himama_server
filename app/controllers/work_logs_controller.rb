class WorkLogsController < ApplicationController
  wrap_parameters :event, include: [:start_time, :end_time]
  before_action :set_work_log, only: [:show, :update, :destroy]

  # GET /work_logs
  def index
    if !params[:username].nil?
      user = User.find_by username: params[:username]
      render json: { error: "User not found" }, status: :not_found and return if user.nil?
      @work_logs = WorkLog.where(["user_id=?", user.id]).order("created_at desc").limit(100)
      render json: @work_logs
    else
      @work_logs = WorkLog.all.order("created_at desc").limit(100)
      render json: @work_logs
    end
  end

  # GET /work_logs/1
  def show
    render json: @work_log
  end

  # POST /work_logs
  def create
    # Should not be able to create a worklog event
    render json: { error: "Function not allowed" }, status: :method_not_allowed
  end

  # PATCH/PUT /work_logs/1
  def update
    old_start_time_event = Event.find(@work_log.start_event_id)
    old_end_time_event = Event.find(@work_log.end_event_id)

    new_start_time = DateTime.parse(work_log_params[:start_time])
    new_end_time = DateTiem.parse(work_log_params[:end_time])

    @work_log.start_time = new_start_time
    @work_log.end_time = new_end_time
    @work_log.time_worked = ((new_end_time - new_start_time) * 24 * 60 * 60).to_i

    old_start_time_event.data = new_start_time.to_s
    old_end_time_event.data = new_end_time.to_s

    if @work_log.save && old_start_time_event.save && old_end_time_event.save
      render json: @work_log, status: :success, location: @work_log
    else
      render json: { error: "Error updating work log" }, status: :internal_server_error
    end
  end

  # DELETE /work_logs/1
  def destroy
    @work_log.status = "Invalid"
    if @work_log.save
      render json: @work_log, status: :ok, location: @work_log
    else
      render json: @work_log.errors, status: :internal_server_error
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_log
      @work_log = WorkLog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def work_log_params
      params.require(:event).permit(:start_time, :end_time)
    end
end
