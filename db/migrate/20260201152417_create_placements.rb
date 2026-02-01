class CreatePlacements < ActiveRecord::Migration[7.2]
  def change
    create_table :placements do |t|
      t.references :schedule, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.integer :position_order

      t.timestamps
    end
  end
end
