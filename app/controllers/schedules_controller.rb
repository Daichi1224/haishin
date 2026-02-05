class SchedulesController < ApplicationController
  def update_memo
    u_id = current_user&.id || session[:user_id]
    @schedule = Schedule.find_or_create_by(date: params[:date], site_id: params[:site_id], user_id: u_id)

    if @schedule.update(memo: params[:memo])
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path }
      end
    else
      redirect_back fallback_location: root_path
    end
  end

  # --- ここから「引き継ぎ」と「リセット」の処理を追加 ---

  def reset_week
    target_date = Date.parse(params[:target_date])
    date_range = target_date..(target_date + 6.days)
    u_id = current_user&.id || session[:user_id]

    # 今週の自分のデータ（メンバー配置・車両・メモすべて）を削除
    Schedule.where(user_id: u_id, date: date_range).destroy_all

    redirect_to dashboard_path(date: target_date), notice: "予定をリセットしました。"
  end

  def copy_pre_week
    target_date = Date.parse(params[:target_date])
    u_id = current_user&.id || session[:user_id]

    # 1. まず今週のデータをリセット（重複を防ぐため）
    Schedule.where(user_id: u_id, date: target_date..(target_date + 6.days)).destroy_all

    # 2. 前週（表示されている日の7日前から1週間分）のデータを取得
    pre_week_range = (target_date - 7.days)..(target_date - 1.day)
    pre_schedules = Schedule.where(user_id: u_id, date: pre_week_range)

    # 3. 前週のデータを1件ずつコピーして、日付を1週間分プラスして保存
    pre_schedules.each do |old_s|
      new_date = old_s.date + 7.days
      new_s = Schedule.create!(
        user_id: u_id,
        site_id: old_s.site_id,
        date: new_date,
        memo: old_s.memo
      )

      # メンバー（配置）のコピー
      old_s.placements.each do |p|
        new_s.placements.create!(member_id: p.member_id, position_order: p.position_order)
      end

      # 車両のコピー
      old_s.vehicle_assignments.each do |va|
        new_s.vehicle_assignments.create!(vehicle_id: va.vehicle_id)
      end
    end

    redirect_to dashboard_path(date: target_date), notice: "前週の情報を引き継ぎました。"
  end
end
