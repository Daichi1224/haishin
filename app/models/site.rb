class Site < ApplicationRecord
  belongs_to :user, optional: true

  acts_as_list column: :position

  has_many :schedules, dependent: :destroy
end
