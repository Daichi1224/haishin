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
    @schedules = Schedule.where(user_id: u_id, date: @start_date..@end_date)
                        .includes(:site, { placements: :member }, { vehicle_assignments: :vehicle })
  end

  def weekly_report
    @base_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @start_date = @base_date.beginning_of_week
    @end_date = @base_date.end_of_week
    @dates = (@start_date..@end_date).to_a

    u_id = current_user&.id || session[:user_id]

    # 【完全解決版】
    # user_id が u_id と一致するもの、もしくは user_id が空(nil)のものを両方持ってくる
    @schedules = Schedule.where(user_id: [u_id, nil], date: @start_date.to_s..@end_date.to_s)
                        .includes(:site, { placements: :member }, { vehicle_assignments: :vehicle })
  end
end
