class Vehicle < ApplicationRecord
  belongs_to :user, optional: true

  acts_as_list column: :position

  has_many :vehicle_assignments
  has_many :placements
end
