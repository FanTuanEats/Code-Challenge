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

require 'rails_helper'

RSpec.describe Assignment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
