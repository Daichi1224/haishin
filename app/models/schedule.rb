class Schedule < ApplicationRecord
  belongs_to :site
  has_many :placements, dependent: :destroy
  has_many :vehicle_assignments, dependent: :destroy
  has_many :vehicles, through: :vehicle_assignments
end
