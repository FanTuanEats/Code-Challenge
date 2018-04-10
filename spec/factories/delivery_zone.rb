# == Schema Information
#
# Table name: delivery_zones
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
    factory :delivery_zone do
        name Faker::Company.name
    end
end