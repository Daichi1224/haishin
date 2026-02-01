class SchedulesController < ApplicationController
  def update_memo
    @schedule = Schedule.find_or_create_by(date: params[:date], site_id: params[:site_id])

    if @schedule.update(memo: params[:memo])
      redirect_to root_path, notice: "メモを保存しました"
    else
      redirect_to root_path, alert: "保存に失敗しました"
    end
  end
end
