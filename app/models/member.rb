class Member < ApplicationRecord
  belongs_to :user, optional: true

  before_create :set_default_position

  private

  def set_default_position
    max_pos = Member.maximum(:position) || 0
    self.position = max_pos + 1
  end
end
