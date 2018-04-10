# == Schema Information
#
# Table name: delivery_zones
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe DeliveryZone, type: :model do
    it { is_expected.to have_many(:assignments) }
    it { is_expected.to have_many(:restaurants) }

    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
end
