class AddPositionToMembers < ActiveRecord::Migration[7.2]
  def change
    add_column :members, :position, :integer
  end
end
