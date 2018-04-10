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

FactoryBot.define do
    factory :assignment do
        delivery_zone
        restaurant
    end
end