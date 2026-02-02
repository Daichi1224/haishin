class PlacementsController < ApplicationController
  def create
    # ViewのID特定のために日付と現場を保持
    @date = params[:date]
    @site = Site.find(params[:site_id])

    # 1. スケジュールを特定または作成
    @schedule = Schedule.find_or_create_by(date: @date, site_id: @site.id)

    # 2. メンバーID取得
    member_ids = params[:member_ids] || []

    # 3. トランザクション処理
    Placement.transaction do
      member_ids.each do |m_id|
        next if @schedule.placements.exists?(member_id: m_id)
        @schedule.placements.create!(member_id: m_id)
      end
    end

    # Turbo Stream形式でレスポンスを返す
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
    redirect_to root_path, notice: "削除しました"
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
    redirect_to root_path, alert: "移動に失敗しました"
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
    redirect_to root_path, alert: "移動に失敗しました"
  end
end
