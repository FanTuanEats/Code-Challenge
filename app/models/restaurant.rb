##
# This class represents a Restaurant
#
# == Schema Information
#
# Table name: restaurants
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  api_key    :uuid
#

class Restaurant < ApplicationRecord
    has_many :meals, dependent: :destroy
    has_many :assignments
    has_many :delivery_zones, through: :assignments
    has_many :restrict_restaurant_delivery_zones, dependent: :destroy
    has_many :restrict_restaurant_days, dependent: :destroy
    before_create :generate_api_key
    after_destroy :destroy_future_assignments

    ##
    # Returns restaurants ordered by those with the last amount of historical delivery assignments ascending, while also
    # filtering out specific ones based on biz rules
    # Params:
    # delivery_zone_id: The ID of delivery zone to sort number of assignments to by
    # day: The day for which the assignment is going to be for
    #   Restaurant.find_least_assigned_available(delivery_zone_id, Date.today)
    def self.find_least_assigned_available(delivery_zone_id, day)
        least_assigned = self
            .find_least_assigned(delivery_zone_id)
            .having("sum(case when assignments.date = '#{day}' THEN 1 ELSE 0 end) < 3") # Having less than 3 delivery zones in the same day
            .having("sum(case when assignments.delivery_zone_id = #{delivery_zone_id} THEN 1 ELSE 0 end) < 1") # Having not already delivered to this delivery zone
        least_assigned = least_assigned.where('restaurants.id not in (?)', self.restricted_ids(delivery_zone_id, day)) unless self.restricted_ids(delivery_zone_id, day).blank?
        least_assigned.first
    end

    private 

    ##
    # Destroys only the assignments in the future
    def destroy_future_assignments
        self.assignments.in_the_future.destroy_all
    end

    ##
    # Generates the unique API key for the restaurant
    def generate_api_key
        begin
            self.api_key = SecureRandom.uuid
        end while Restaurant.exists?(api_key: api_key)
    end

    ##
    # Returns the IDs of restaurants that are restricted from delivering to the input zone and on the input day
    # Params:
    # delivery_zone_id: The ID of delivery zone to sort number of assignments to by
    # day: The day for which the assignment is going to be for
    #   self.restrict_ids(delivery_zone_id, Date.today)
    def self.restricted_ids(delivery_zone_id, day)
        restrict_ids = RestrictRestaurantDay.where(day: day.wday).pluck(:restaurant_id)
        restrict_ids.concat RestrictRestaurantDeliveryZone.where(delivery_zone_id: delivery_zone_id).pluck(:restaurant_id)
        restrict_ids
    end

    ##
    # Returns restaurants ordered by those with the least amount of historical delivery assignements to the input zone ascending
    # Params:
    # delivery_zone_id: The ID of delivery zone to sort number of assignments to by
    #   self.find_least_assigned(delivery_zone)
    def self.find_least_assigned(delivery_zone_id)
        Restaurant.select("restaurants.id, 
            sum(CASE WHEN assignments.delivery_zone_id = #{delivery_zone_id} THEN 1 ELSE 0 end) AS assignment_count")
            .left_joins(:assignments)
            .group(:id).order('COUNT(assignments.id) asc, assignment_count asc, restaurants.created_at asc')
    end
    
end
