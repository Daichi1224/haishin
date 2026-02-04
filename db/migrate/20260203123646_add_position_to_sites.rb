class AddPositionToSites < ActiveRecord::Migration[7.2]
  def change
    add_column :sites, :position, :integer
  end
end
