class AddActiveToSites < ActiveRecord::Migration[7.0]
  def change
    add_column :sites, :active, :boolean, default: true
  end
end
