class CreateRestrictRestaurantDeliveryZones < ActiveRecord::Migration[5.1]
  def change
    create_table :restrict_restaurant_delivery_zones do |t|
      t.integer :restaurant_id
      t.integer :delivery_zone_id

      t.timestamps
    end
  end
end
