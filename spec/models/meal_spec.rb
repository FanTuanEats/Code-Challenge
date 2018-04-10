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

require 'rails_helper'

RSpec.describe Meal, type: :model do
    it { is_expected.to belong_to(:restaurant) }

    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:restaurant_id) }
    it { is_expected.to respond_to(:restaurant) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
end
