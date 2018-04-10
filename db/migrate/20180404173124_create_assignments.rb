class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.date :date
      t.integer :delivery_zone_id
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
