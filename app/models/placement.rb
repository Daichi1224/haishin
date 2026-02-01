class Placement < ApplicationRecord
  belongs_to :schedule
  belongs_to :member

  # 新しく登録する際、一番最後の順番を自動で割り振る
  before_create :set_position_order

  private

  def set_position_order
    max_order = schedule.placements.maximum(:position_order) || 0
    self.position_order = max_order + 1
  end
end
