class DashboardsController < ApplicationController
  def show
    @base_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @start_date = @base_date.beginning_of_week
    @end_date = @base_date.end_of_week
    @dates = (@start_date..@end_date).to_a

    u_id = current_user&.id || session[:user_id]

    @sites = Site.where(user_id: u_id, active: true).order(:position)
    @members = Member.where(user_id: u_id, active: true).order(:position)
    @vehicles = Vehicle.where(user_id: u_id, active: true).order(:position)

    # 修正：現場IDを基準にして、自分の現場に紐づく予定だけを確実に持ってくる
    @schedules = Schedule.where(site_id: @sites.pluck(:id), date: @start_date..@end_date)
                        .includes(:site, { placements: :member }, { vehicle_assignments: :vehicle })
  end

  def weekly_report
    @base_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @start_date = @base_date.beginning_of_week
    @end_date = @base_date.end_of_week
    @dates = (@start_date..@end_date).to_a

    u_id = current_user&.id || session[:user_id]
    @sites = Site.where(user_id: u_id, active: true)

    # 修正：weekly_reportも同様に nil 許可を廃止し、自分の現場IDで絞り込む
    @schedules = Schedule.where(site_id: @sites.pluck(:id), date: @start_date.to_s..@end_date.to_s)
                        .includes(:site, { placements: :member }, { vehicle_assignments: :vehicle })
  end
end
