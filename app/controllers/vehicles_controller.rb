class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[ show edit update destroy move_up move_down ]

  def index
    u_id = get_current_u_id

    if u_id.present?
      @vehicles = Vehicle.where(user_id: u_id, active: true).order(:position)
    else
      @vehicles = Vehicle.none
    end
  end

  def show
  end

  def new
    @vehicle = Vehicle.new
  end

  def edit
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    u_id = get_current_u_id
    @vehicle.user_id = u_id
    @vehicle.active = true
    # 自分の車両リストの末尾に追加されるように計算
    @vehicle.position = (Vehicle.where(user_id: u_id).maximum(:position) || 0) + 1

    respond_to do |format|
      if @vehicle.save
        format.turbo_stream
        format.html { redirect_to vehicles_path, notice: "車両を登録しました" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.turbo_stream
        format.html { redirect_to vehicles_path, notice: "車両情報を更新しました" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @vehicle.update(active: false)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to vehicles_path, notice: '車両を非表示にしました' }
    end
  end

  def move_up
    u_id = get_current_u_id
    higher_vehicle = Vehicle.where(user_id: u_id, active: true).where("position < ?", @vehicle.position).order(position: :desc).first
    if higher_vehicle
      current_pos = @vehicle.position
      @vehicle.update(position: higher_vehicle.position)
      higher_vehicle.update(position: current_pos)
    end
    redirect_to vehicles_path
  end

  def move_down
    u_id = get_current_u_id
    lower_vehicle = Vehicle.where(user_id: u_id, active: true).where("position > ?", @vehicle.position).order(position: :asc).first
    if lower_vehicle
      current_pos = @vehicle.position
      @vehicle.update(position: lower_vehicle.position)
      lower_vehicle.update(position: current_pos)
    end
    redirect_to vehicles_path
  end

  private

  def set_vehicle
    u_id = get_current_u_id
    @vehicle = Vehicle.where(user_id: u_id).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to vehicles_path, alert: "指定された車両が見つかりません。"
  end

  def get_current_u_id
    if defined?(current_user) && current_user.respond_to?(:id) && current_user.present?
      current_user.id
    else
      session[:user_id]
    end
  end

  def vehicle_params
    params.require(:vehicle).permit(:name, :user_id, :position, :active)
  end
end
