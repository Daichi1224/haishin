class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[ show edit update destroy ]

  def index
    u_id = nil
    if defined?(current_user) && current_user.respond_to?(:id)
      u_id = current_user.id
    elsif session[:user_id]
      u_id = session[:user_id]
    end

    @vehicles = Vehicle.where(user_id: u_id).order(:position)
  end

  # GET /vehicles/1 or /vehicles/1.json
  def show
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
  end

  # GET /vehicles/1/edit
  def edit
  end

  # POST /vehicles or /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)
    u_id = nil
    if defined?(current_user) && current_user.respond_to?(:id) && current_user.present?
      u_id = current_user.id
    elsif session[:user_id]
      u_id = session[:user_id]
    end
    @vehicle.user_id = u_id
    @vehicle.active = true

    @vehicle.position = (Vehicle.maximum(:position) || 0) + 1
    @vehicle.active = true

    respond_to do |format|
      if @vehicle.save
        format.turbo_stream
        format.html { redirect_to vehicles_path, notice: "車両を登録しました" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1 or /vehicles/1.json
  def update
    @vehicle = Vehicle.find(params[:id])
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.turbo_stream
        format.html { redirect_to vehicles_path, notice: "車両情報を更新しました" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1 or /vehicles/1.json
  def destroy
    @vehicle = Vehicle.find(params[:id])
    @vehicle.update(active: false)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to vehicles_path, notice: '車両を非表示にしました' }
    end
  end

  def move_up
    @vehicle = Vehicle.find(params[:id])
    @vehicle.move_higher
    redirect_to vehicles_path
  end

  def move_down
    @vehicle = Vehicle.find(params[:id])
    @vehicle.move_lower
    redirect_to vehicles_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_params
      params.require(:vehicle).permit(:name)
    end
end
