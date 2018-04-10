##
# This class represents the biz rule that a restaurant does not deliver to the specified zone
#
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
    belongs_to :restaurant
    belongs_to :delivery_zone
    after_create :destroy_future_assignments

    private 

    ##
    # Destroys only the assignments in the future where the restaurant is restricted by the delivery zone
    def destroy_future_assignments
        Assignment.in_the_future
            .where(restaurant_id: self.restaurant_id)
            .where(delivery_zone_id: self.delivery_zone_id)
            .destroy_all
    end
end
