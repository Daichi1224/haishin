class DashboardsController < ApplicationController
  def show
    @base_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @start_date = @base_date.beginning_of_week
    @end_date = @base_date.end_of_week
    @dates = (@start_date..@end_date).to_a

    u_id = nil

    if defined?(current_user) && current_user.respond_to?(:id) && current_user.present?
      u_id = current_user.id
    elsif session[:user_id]
      u_id = session[:user_id]
    end

    @sites = Site.where(user_id: u_id, active: true).order(:position)
    @members = Member.where(user_id: u_id, active: true).order(:position)
    @vehicles = Vehicle.where(user_id: u_id, active: true).order(:position)
    @schedules = Schedule.where(user_id: u_id, date: @start_date..@end_date).includes(:placements, :vehicle_assignments)
  end

  def weekly_report
    @base_date = params[:date] ? Date.parse(params[:date]) : Date.today.beginning_of_week
    @dates = (@base_date..@base_date + 6.days).to_a

    u_id = nil
    if defined?(current_user) && current_user.respond_to?(:id)
      u_id = current_user.id
    elsif session[:user_id]
      u_id = session[:user_id]
    end

    @schedules = Schedule.where(user_id: u_id, date: @dates)
                         .includes(:site, placements: :member, vehicle_assignments: :vehicle)
  end
end
