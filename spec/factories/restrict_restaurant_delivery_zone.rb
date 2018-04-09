# == Schema Information
#
# Table name: restrict_restaurant_delivery_zones
#
#  id               :integer          not null, primary key
#  restaurant_id    :integer
#  delivery_zone_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryBot.define do
    factory :restrict_restaurant_delivery_zone do
        restaurant
        delivery_zone
    end
end