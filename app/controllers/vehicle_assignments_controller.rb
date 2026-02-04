class VehicleAssignmentsController < ApplicationController
  def create
    @schedule = Schedule.find_or_create_by(date: params[:date], site_id: params[:site_id])
    vehicle_ids = params[:vehicle_ids] || []

    VehicleAssignment.transaction do
      @schedule.vehicle_assignments.destroy_all
      vehicle_ids.each do |v_id|
        @schedule.vehicle_assignments.create!(vehicle_id: v_id)
      end
    end

    redirect_to dashboard_path(date: @schedule.date), notice: "車両を更新しました"
  end
end
