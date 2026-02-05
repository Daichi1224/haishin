class VehicleAssignmentsController < ApplicationController
  def create
    # ゲスト・一般ユーザー共通で、現在のユーザーIDを確実に取得
    u_id = current_user.id

    @schedule = Schedule.find_or_create_by(date: params[:date], site_id: params[:site_id]) do |s|
      s.user_id = u_id
    end

    # 万が一、既存のスケジュールにuser_idがなかった場合の補完ロジック
    @schedule.update(user_id: u_id) if @schedule.user_id.nil?

    vehicle_ids = params[:vehicle_ids] || []

    VehicleAssignment.transaction do
      # --- ここが重要！幽霊データを抹殺するロジック ---
      # 現在のスケジュールの車両割り当てを一度すべて削除
      @schedule.vehicle_assignments.destroy_all

      # チェックが入っている車両だけを新規作成
      # vehicle_idsが空（チェック全外し）なら、レコードは0になり印刷画面からも消える
      vehicle_ids.each do |v_id|
        @schedule.vehicle_assignments.create!(vehicle_id: v_id)
      end
    end

    # リダイレクト先をルートパスに統一（日付パラメータを維持）
    redirect_to root_path(date: @schedule.date), notice: "車両を更新しました"
  end
end
