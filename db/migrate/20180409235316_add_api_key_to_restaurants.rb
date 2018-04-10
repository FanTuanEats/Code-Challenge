class AddApiKeyToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :api_key, :uuid
    add_index :restaurants, :api_key, unique: true
  end
end
