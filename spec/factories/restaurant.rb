# == Schema Information
#
# Table name: restaurants
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
    factory :restaurant do
        name Faker::Company.name
    end
end