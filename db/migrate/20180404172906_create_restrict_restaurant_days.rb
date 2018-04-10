class CreateRestrictRestaurantDays < ActiveRecord::Migration[5.1]
  def change
    create_table :restrict_restaurant_days do |t|
      t.integer :restaurant_id
      t.integer :day

      t.timestamps
    end
  end
end
