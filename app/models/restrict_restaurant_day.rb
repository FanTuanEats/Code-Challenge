##
# This class represents the biz rule that a restaurant does not deliver on a specific day of the week.
#
# == Schema Information
#
# Table name: restrict_restaurant_days
#
#  id            :integer          not null, primary key
#  restaurant_id :integer
#  day           :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class RestrictRestaurantDay < ApplicationRecord
    belongs_to :restaurant

    enum day: [ :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday ]
end
