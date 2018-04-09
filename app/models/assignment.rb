##
# This class represents the assignment of a restaurant to a delivery zone for a specific date.
#
# == Schema Information
#
# Table name: assignments
#
#  id               :integer          not null, primary key
#  date             :date
#  delivery_zone_id :integer
#  restaurant_id    :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Assignment < ApplicationRecord
    belongs_to :delivery_zone
    belongs_to :restaurant

    ##
    # Creates assignments for input date range
    # Params:
    # start_date: the start date to begin making assignments for
    # day_count: length of days from start_date to make assigns for
    #   Assignment.assign_deliveries_for_date_range(Date.today, 7)
    def self.assign_deliveries_for_date_range(start_date, day_count)
        # If no restaurants, none to assign.
        return if Restaurant.all.size == 0 
        day = start_date
        # For the next 7 days
        (0..day_count).each do | day_count |
            day = day + 1.day
            self.assign_deliveries_for_day(day)
        end
    end

    ##
    # Assigns a company to a delivery zone for a day, applying biz rules
    # Params:
    # day: The date to make the assignment for
    #   Assignment.assign_deliveries_for_day(Date.today)
    def self.assign_deliveries_for_day(day)
        # Assign companies to all delivery zones
        DeliveryZone.all.order("created_at asc").each do | delivery_zone |
            # Assign up to 4 restaurants
            while delivery_zone.assignments.where(date: day).count < 4
                Assignment.new(
                    date: day,
                    delivery_zone_id: delivery_zone.id,
                    restaurant_id: Restaurant.find_least_assigned_available(delivery_zone.id, day).id
                ).save!
            end
        end
    end

end
