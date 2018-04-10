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

require 'rails_helper'

RSpec.describe RestrictRestaurantDay, type: :model do
    it { is_expected.to belong_to(:restaurant) }

    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:restaurant_id) }
    it { is_expected.to respond_to(:restaurant) }
    it { is_expected.to respond_to(:day) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
end
