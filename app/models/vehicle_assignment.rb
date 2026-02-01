class VehicleAssignment < ApplicationRecord
  belongs_to :schedule
  belongs_to :vehicle
end
