# == Schema Information
#
# Table name: restaurants
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  api_key    :uuid
#

require 'rails_helper'

RSpec.describe Restaurant, type: :model do
    it { is_expected.to have_many(:meals) }
    it { is_expected.to have_many(:assignments) }
    it { is_expected.to have_many(:delivery_zones) }
    it { is_expected.to have_many(:restrict_restaurant_days) }

    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:name) } 
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }


    describe 'self.find_least_assigned' do
        context 'when no assignments have been made' do
            before do
                @restaurants = FactoryBot.create_list(:restaurant, 3)
                @delivery_zone = FactoryBot.create(:delivery_zone)
                @r = Restaurant.find_least_assigned(@delivery_zone.id)
            end
            it 'should return the restaurants in created_at ascending order' do
                expect(@r.length).to eq(3)
            end
        end

        context 'when assignments have been made' do
            before do
                @restaurants = FactoryBot.create_list(:restaurant, 3)
                @delivery_zone = FactoryBot.create(:delivery_zone)
                @restaurants.each do | restaurant |
                    Assignment.new(
                        delivery_zone_id: @delivery_zone.id,
                        restaurant_id: restaurant.id,
                        date: Date.today
                    ).save!
                end
                
                @r = Restaurant.find_least_assigned(@delivery_zone.id)
            end
            it 'should return the restaurants in order by least amount of historical delivery assignments' do
                expect(@r.length).to eq(3)
            end
        end
    end


    describe 'self.restricted_ids' do
        context 'when no restrictions for delivery zone' do
            before do
                delivery_zones = FactoryBot.create_list(:delivery_zone, 3)
                @restricted_ids = Restaurant.send :restricted_ids, delivery_zones.first.id, Date.today
            end
            it 'should not return any ids' do
                expect(@restricted_ids.size).to eq(0)
            end
        end

        context 'when a restaurant is restricted from delivering on a weekday' do
            before do
                delivery_zones = FactoryBot.create_list(:delivery_zone, 3)
                @restaurant = FactoryBot.create(:restaurant)
                RestrictRestaurantDay.new(
                    restaurant_id: @restaurant.id,
                    day: Date.today.wday
                ).save!

                @restricted_ids = Restaurant.send :restricted_ids, delivery_zones.first.id, Date.today
            end
            it 'should return the restricted restaurant ID' do
                expect(@restricted_ids.size).to eq(1)
                expect(@restricted_ids.first).to eq(@restaurant.id)
            end
        end

        context 'when a restaurant is restricted from a delivery zone' do
            before do
                @delivery_zone = FactoryBot.create(:delivery_zone)
                @restaurant = FactoryBot.create(:restaurant)
                RestrictRestaurantDeliveryZone.new(
                    restaurant_id: @restaurant.id,
                    delivery_zone_id: @delivery_zone.id
                ).save!

                @restricted_ids = Restaurant.send :restricted_ids, @delivery_zone.id, Date.today
            end
            it 'should return the restricted restaurant ID' do
                expect(@restricted_ids.size).to eq(1)
                expect(@restricted_ids.first).to eq(@restaurant.id)
            end
        end

    end


end
