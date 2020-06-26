class EventsController < ApplicationController
  wrap_parameters :event, include: [:username, :type, :data]
  before_action :set_event, only: [:show, :update, :destroy]

  # GET /events
  def index
    if !params[:username].nil?
      user = User.find_by username: params[:username]
      render json: { error: "User not found" }, status: :not_found and return if user.nil?
      @events = Event.where(["user_id=?", user.id]).order("created_at desc").limit(100)
      render json: @events
    else
      @events = Event.all.order("created_at desc").limit(100)
      render json: @events
    end
  end

  # GET /events/1
  def show
    render json: @event
  end

  # POST /events
  def create
    username = event_params["username"].downcase
    event_type = event_params["type"].downcase
    current_time = DateTime.current

    user = User.find_by username: username
    render json: { error: "User not found" }, status: :not_found and return if user.nil?

    if event_type == "clock"
      last_event = Event.where(["user_id=?", user.id]).last
      if last_event.nil? || last_event.event_type == "Clock Out"
        type = "Clock In"
      else
        type = "Clock Out"
      end
      @event = Event.new(user_id: user.id, event_type: type, data: current_time.to_s, data_type: "DateTime")
    else
      @event = Event.new(user_id: user.id, event_type: event_type, data: event_params[:data], data_type: "String")
    end

    if @event.save
      if type == "Clock Out"
        start_time = DateTime.parse(last_event.data)
        time_worked = ((current_time - start_time) * 24 * 60 * 60).to_i
        WorkLog.create!(user_id: user.id, start_time: start_time, end_time: current_time, time_worked: time_worked, start_event_id: last_event.id, end_event_id: @event.id)
      end
      if type === "Clock Out"
        render json: { event: @event, time_worked: time_worked }, status: :created, location: @event
      else
        render json: { event: @event }, status: :created, location: @event
      end
    else
      render json: { error: @event.errors }, status: :internal_server_error
    end

  end

  # PATCH/PUT /events/1
  def update
    # Should not be able to update an event
    render json: { error: "Function not allowed" }, status: :method_not_allowed
  end

  # DELETE /events/1
  def destroy
    # Should not be able to destroy an event
    render json: { error: "Function not allowed" }, status: :method_not_allowed
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:username, :type, :data)
    end
end
