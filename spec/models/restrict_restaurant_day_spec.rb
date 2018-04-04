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
  pending "add some examples to (or delete) #{__FILE__}"
end
