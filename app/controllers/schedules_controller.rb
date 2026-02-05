class SchedulesController < ApplicationController
  def update_memo
    u_id = current_user&.id || session[:user_id]
    @schedule = Schedule.find_or_create_by(date: params[:date], site_id: params[:site_id]) do |s|
      s.user_id = u_id
    end
    @schedule.update(user_id: u_id) if @schedule.user_id.nil?

    if @schedule.update(memo: params[:memo])
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path }
      end
    else
      redirect_back fallback_location: root_path
    end
  end
end
