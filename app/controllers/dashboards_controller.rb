class DashboardsController < ApplicationController
  def show
    # 表示したい基準日（パラメーターがなければ今日）
    @base_date = params[:date] ? Date.parse(params[:date]) : Date.today

    # 月曜から日曜までの1週間分の日付を取得
    @start_date = @base_date.beginning_of_week
    @end_date = @base_date.end_of_week
    @dates = (@start_date..@end_date).to_a

    # 画面に表示するためのデータを準備
    @sites = Site.all
    @members = Member.all
    @vehicles = Vehicle.all

    # 1週間分のスケジュールをまとめて取得
    @schedules = Schedule.where(date: @start_date..@end_date).includes(:placements)
  end
end
