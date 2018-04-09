# == Schema Information
#
# Table name: meals
#
#  id            :integer          not null, primary key
#  name          :string
#  restaurant_id :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
    factory :meal do
        name Faker::Food.dish
        restaurnt
    end
end