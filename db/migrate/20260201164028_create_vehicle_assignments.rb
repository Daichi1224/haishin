class CreateVehicleAssignments < ActiveRecord::Migration[7.2]
  def change
    create_table :vehicle_assignments do |t|
      t.references :schedule, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
