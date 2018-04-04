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

require 'rails_helper'

RSpec.describe RestrictRestaurantDeliveryZone, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
