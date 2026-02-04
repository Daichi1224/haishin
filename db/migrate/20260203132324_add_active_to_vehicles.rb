class AddActiveToVehicles < ActiveRecord::Migration[7.0]
  def change
    add_column :vehicles, :active, :boolean, default: true
  end
end
