class WorkLogsController < ApplicationController
  before_action :set_work_log, only: [:show, :update, :destroy]

  # GET /work_logs
  def index
    @work_logs = WorkLog.all

    render json: @work_logs
  end

  # GET /work_logs/1
  def show
    render json: @work_log
  end

  # POST /work_logs
  def create
    @work_log = WorkLog.new(work_log_params)

    if @work_log.save
      render json: @work_log, status: :created, location: @work_log
    else
      render json: @work_log.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /work_logs/1
  def update
    if @work_log.update(work_log_params)
      render json: @work_log
    else
      render json: @work_log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /work_logs/1
  def destroy
    @work_log.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_log
      @work_log = WorkLog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def work_log_params
      params.fetch(:work_log, {})
    end
end
