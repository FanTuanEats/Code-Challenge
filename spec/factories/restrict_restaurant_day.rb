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

FactoryBot.define do
    factory :restrict_restaurant_day do
        restaurant
    end
end