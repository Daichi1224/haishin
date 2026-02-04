class AddPositionToVehicles < ActiveRecord::Migration[7.2]
  def change
    add_column :vehicles, :position, :integer
  end
end
