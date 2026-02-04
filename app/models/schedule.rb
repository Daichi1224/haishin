class Schedule < ApplicationRecord
  belongs_to :site
  belongs_to :user, optional: true

  has_many :placements, dependent: :destroy
  has_many :vehicle_assignments, dependent: :destroy
  has_many :members, through: :placements
  has_many :vehicles, through: :vehicle_assignments
end
