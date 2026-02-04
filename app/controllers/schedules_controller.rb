class SchedulesController < ApplicationController
  def update_memo
    # user_idを使わず、シンプルに日付と現場だけで特定する元の形に戻します
    @schedule = Schedule.find_or_create_by(
      date: params[:date],
      site_id: params[:site_id]
    )

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
