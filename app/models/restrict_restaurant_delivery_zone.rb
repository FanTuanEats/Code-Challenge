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

class RestrictRestaurantDeliveryZone < ApplicationRecord
end
