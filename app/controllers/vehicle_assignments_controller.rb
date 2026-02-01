class VehicleAssignmentsController < ApplicationController
  def create
    @schedule = Schedule.find_or_create_by(date: params[:date], site_id: params[:site_id])

    # 送られてきた車両IDの配列を処理
    vehicle_ids = params[:vehicle_ids] || []

    VehicleAssignment.transaction do
      # 一度その日のその現場の車両配置をリセットして登録し直す（更新が楽なため）
      @schedule.vehicle_assignments.destroy_all
      vehicle_ids.each do |v_id|
        @schedule.vehicle_assignments.create!(vehicle_id: v_id)
      end
    end

    redirect_to root_path, notice: "車両を更新しました"
  end
end
