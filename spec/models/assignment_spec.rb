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
    it { is_expected.to belong_to(:delivery_zone) }
    it { is_expected.to belong_to(:restaurant) }

    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:date) }
    it { is_expected.to respond_to(:delivery_zone_id) }
    it { is_expected.to respond_to(:delivery_zone) }
    it { is_expected.to respond_to(:restaurant_id) } 
    it { is_expected.to respond_to(:restaurant) } 
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }

    describe 'self.assign_deliveries_for_day' do
        context 'when no restaurants' do
            before do
                delivery_zones = FactoryBot.create_list(:delivery_zone, 1)
                Assignment.assign_deliveries_for_day(Date.today)
            end
            it 'should not create any assignments' do
                expect(Assignment.all.size).to eq(0)
            end
        end

        context 'when there is a single restaurant' do

            context 'and one delivery zone' do
                context 'and the restaurant is restricted from delivering on a specific day of the week' do
                    before do
                        @delivery_zone = FactoryBot.create(:delivery_zone)
        
                        # Create Restaurant
                        @restaurant = FactoryBot.create(:restaurant)

                        # Create restriction
                        RestrictRestaurantDay.new(
                            restaurant_id: @restaurant.id,
                            day: Date.today.wday
                        ).save!

                        Assignment.assign_deliveries_for_day(Date.today)
                    end
                    it 'should NOT create an delivery assignment' do
                        expect(Assignment.all.size).to eq(0)
                    end
                end

                context 'and the restaurant is restricted from delivering to the zone' do
                    before do
                        @delivery_zone = FactoryBot.create(:delivery_zone)
        
                        # Create Restaurant
                        @restaurant = FactoryBot.create(:restaurant)

                        # Create restriction
                        RestrictRestaurantDeliveryZone.new(
                            restaurant_id: @restaurant.id,
                            delivery_zone_id: @delivery_zone.id
                        ).save!

                        Assignment.assign_deliveries_for_day(Date.today)
                    end
                    it 'should NOT create an delivery assignment' do
                        expect(Assignment.all.size).to eq(0)
                    end
                end

                context 'and the restaurant is NOT restricted from delivering to the zone and NOT restricted from delivering on a specific day of the week' do
                    before do
                        @delivery_zone = FactoryBot.create(:delivery_zone)
        
                        # Create Restaurant
                        @restaurant = FactoryBot.create(:restaurant)
                        Assignment.assign_deliveries_for_day(Date.today)
                    end
                    it 'should create an delivery assignment' do
                        expect(Assignment.all.size).to eq(1)
        
                        assignment = Assignment.where(date: Date.today).first
        
                        expect(assignment.delivery_zone_id).to eq(@delivery_zone.id)
                        expect(assignment.restaurant_id).to eq(@restaurant.id)
                    end
                end
            end

            context 'and more than 3 delivery zones' do
                before do
                    @delivery_zones = FactoryBot.create_list(:delivery_zone, 4)
    
                    # Create Restaurant
                    @restaurant = FactoryBot.create(:restaurant)
                    Assignment.assign_deliveries_for_day(Date.today)
                end
                it 'should create an delivery assignment for at most 3 of the zones' do
                    expect(Assignment.all.size).to eq(3)
                    assignments = Assignment.where(date: Date.today)
                    assignments.each do | assignment |
                        expect(assignment.restaurant_id).to eq(@restaurant.id)
                    end
                end
            end
            
        end

    end
end
