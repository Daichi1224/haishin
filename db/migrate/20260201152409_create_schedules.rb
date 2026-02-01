class CreateSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :schedules do |t|
      t.date :date
      t.references :site, null: false, foreign_key: true
      t.text :memo
      t.integer :user_id

      t.timestamps
    end
  end
end
