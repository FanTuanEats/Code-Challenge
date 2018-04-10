##
# This class represents the a meal.
#
# == Schema Information
#
# Table name: meals
#
#  id            :integer          not null, primary key
#  name          :string
#  restaurant_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Meal < ApplicationRecord
    belongs_to :restaurant
end
