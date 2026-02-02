class DashboardsController < ApplicationController
  before_action :logged_in_user

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

  def weekly_report
    # 表示の基準日（月曜日）を設定
    @base_date = params[:date] ? Date.parse(params[:date]) : Date.today.beginning_of_week
    @dates = (@base_date..@base_date + 6.days).to_a

    # その期間の全スケジュールを、現場・メンバー・車両・メモを含めて一気に取得
    @schedules = Schedule.where(date: @dates).includes(:site, placements: :member, vehicle_assignments: :vehicle)
  end
end
