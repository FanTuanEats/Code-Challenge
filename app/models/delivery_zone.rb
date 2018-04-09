##
# This class represents a delivery zone
#
# == Schema Information
#
# Table name: delivery_zones
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DeliveryZone < ApplicationRecord
    has_many :assignments
    has_many :restaurants, through: :assignments
end
