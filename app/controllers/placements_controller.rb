class PlacementsController < ApplicationController
  def create
    @date = params[:date]
    @site = Site.find(params[:site_id])

    # ゲストでもID持ちでも、current_userを使えば安全に特定可能
    u_id = current_user.id
    @schedule = Schedule.find_or_create_by(date: @date, site_id: @site.id) do |s|
      s.user_id = u_id
    end

    # 万が一user_idが空なら補完
    @schedule.update(user_id: u_id) if @schedule.user_id.nil?

    member_ids = params[:member_ids] || []

    Placement.transaction do
      # --- ここがポイント！ ---
      # 1. 一度、このスケジュールの配置を全て削除（リセット）
      @schedule.placements.destroy_all

      # 2. チェックが入っているメンバーだけを新しく作り直す
      # member_ids が空なら、何も作られない（＝レコードが0になる）
      member_ids.each do |m_id|
        @schedule.placements.create!(member_id: m_id)
      end
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path(date: @date), notice: "配置を更新しました" }
    end
  rescue => e
    logger.error "Batch Create Error: #{e.message}"
    redirect_to root_path, alert: "エラーが発生しました"
  end

  def destroy
    @placement = Placement.find(params[:id])
    @placement.destroy
    redirect_to dashboard_path(date: @placement.schedule.date)
  end

  def move_up
    @placement = Placement.find(params[:id])
    # 自分より一つ上の「一番近い（order descの最初）」人を探す
    higher_item = @placement.schedule.placements.where("position_order < ?", @placement.position_order).order(position_order: :desc).first

    if higher_item
      # トランザクション（2つの更新をセットで行う）
      Placement.transaction do
        old_order = @placement.position_order
        @placement.update!(position_order: higher_item.position_order)
        higher_item.update!(position_order: old_order)
      end
    end
    redirect_to root_path
  rescue => e
    logger.error "Move Up Error: #{e.message}"
    redirect_to dashboard_path(date: @placement.schedule.date)
  end

  def move_down
    @placement = Placement.find(params[:id])
    # 自分より一つ下の「一番近い（order ascの最初）」人を探す
    lower_item = @placement.schedule.placements.where("position_order > ?", @placement.position_order).order(position_order: :asc).first

    if lower_item
      Placement.transaction do
        old_order = @placement.position_order
        @placement.update!(position_order: lower_item.position_order)
        lower_item.update!(position_order: old_order)
      end
    end
    redirect_to root_path
  rescue => e
    logger.error "Move Down Error: #{e.message}"
    redirect_to dashboard_path(date: @placement.schedule.date)
  end
end
