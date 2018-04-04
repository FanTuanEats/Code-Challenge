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

class Assignment < ApplicationRecord
end
