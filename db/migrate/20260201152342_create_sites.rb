class CreateSites < ActiveRecord::Migration[7.2]
  def change
    create_table :sites do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
