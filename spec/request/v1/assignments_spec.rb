require 'rails_helper'
require 'api_helper'
require 'log_utility'
describe V1::AssignmentsController, type: :request do

    before(:all) do
        @delivery_zones = FactoryBot.create_list(:delivery_zone, 3)
        @restaurants = FactoryBot.create_list(:restaurant, 9)
        Assignment.assign_deliveries_for_day(Date.today)
        Assignment.assign_deliveries_for_day(Date.today + 1.day)
        @assignments = Assignment.all
    end
    
    after(:all) do
        Restaurant.all.each { |r| r.destroy! }
        Assignment.all.each { |a| a.destroy! }
    end

    describe 'GET' do

        it 'should fail when not provided an API key' do 
            get '/v1/assignments'
            expect(response).to be_success
            body = JSON.parse(response.body)
            test_failed_response_structure(body)
            test_bad_request_response(response, "Required parameter missing: api_key")
        end

        it 'should fail when not provided an API key in an improper format' do 
            get '/v1/assignments', params: { api_key: 'foobar' }
            expect(response).to be_success
            body = JSON.parse(response.body)
            test_failed_response_structure(body)
            test_bad_request_response(response, "Invalid UUID: foobar")
        end

        it 'should fail when not provided an invalid API key' do 
            invalid_key = ''
            begin
                invalid_key = SecureRandom.uuid
            end while Restaurant.exists?( api_key: invalid_key )
            get '/v1/assignments', params: { api_key: invalid_key }
            expect(response).to be_success
            body = JSON.parse(response.body)
            test_failed_response_structure(body)
            test_forbidden_request_response(response, "Invalid API Key: #{invalid_key}")
        end

        context 'when day is passed' do
            # @todo - Have a test for valid day format and valid day like invalid 13 month or an invalid day of month
            it 'should return only the assignments for the restaurant for that day' do
                get '/v1/assignments', params: { api_key: @restaurants.first.api_key, day: (Date.today + 1.day) }
                
                expect(response).to be_success
                body = JSON.parse(response.body)
                test_basic_response_structure(body)
                
                assignments = Assignment.where( date: (Date.today + 1.day), restaurant_id: @restaurants.first )

                test_pagination(body, 1, 10, assignments.count)
                expect(body['data']['output'].length).to eq( assignments.length > 10 ? 10 : assignments.length )

                body['data']['output'].each_with_index do | assignment, index |
                    expect(assignment).to include('id')
                    expect(assignment).to include('date')
                    expect(assignment['date']).to eq((Date.today + 1.day).strftime("%Y-%m-%d"))
                    
                    expect(assignment).to include('delivery_zone')
                    expect(assignment['delivery_zone']).to include('id')
                    expect(assignment['delivery_zone']).to include('name')

                    expect(assignment).to include('restaurant')
                    expect(assignment['restaurant']).to include('id')
                    expect(assignment['restaurant']).to include('name')
                    expect(assignment['restaurant']).to include('meals')

                    assignment['restaurant']['meals'].each do | meal |
                        expect(meal).to include('id')
                        expect(meal).to include('name')
                    end
                end
            end
        end

        context 'when zone_id is passed' do
            it 'should return only the assignments for the specific delivery zone passed' do
                get '/v1/assignments', params: { api_key: @restaurants.first.api_key, zone_id: @delivery_zones.first.id }
                
                expect(response).to be_success
                body = JSON.parse(response.body)
                test_basic_response_structure(body)
                
                assignments = Assignment.where( delivery_zone_id: @delivery_zones.first.id, restaurant_id: @restaurants.first )

                test_pagination(body, 1, 10, assignments.count)
                expect(body['data']['output'].length).to eq( assignments.length > 10 ? 10 : assignments.length )

                body['data']['output'].each_with_index do | assignment, index |
                    expect(assignment).to include('id')
                    expect(assignment).to include('date')
                    
                    expect(assignment).to include('delivery_zone')
                    expect(assignment['delivery_zone']).to include('id')
                    expect(assignment['delivery_zone']['id']).to eq(@delivery_zones.first.id)
                    expect(assignment['delivery_zone']).to include('name')

                    expect(assignment).to include('restaurant')
                    expect(assignment['restaurant']).to include('id')
                    expect(assignment['restaurant']).to include('name')
                    expect(assignment['restaurant']).to include('meals')

                    assignment['restaurant']['meals'].each do | meal |
                        expect(meal).to include('id')
                        expect(meal).to include('name')
                    end
                end
            end

        end

        context 'when day and zone_id is passed' do
            it 'should return assignments for the specified day in the specified delivery zone' do
                get '/v1/assignments', params: { api_key: @restaurants.first.api_key, zone_id: @delivery_zones.first.id, day: (Date.today + 1.day) }
                
                expect(response).to be_success
                body = JSON.parse(response.body)
                test_basic_response_structure(body)
                
                assignments = Assignment.where( date: (Date.today + 1.day), delivery_zone_id: @delivery_zones.first.id, restaurant_id: @restaurants.first )

                test_pagination(body, 1, 10, assignments.count)
                expect(body['data']['output'].length).to eq( assignments.length > 10 ? 10 : assignments.length )

                body['data']['output'].each_with_index do | assignment, index |
                    expect(assignment).to include('id')
                    expect(assignment).to include('date')
                    expect(assignment['date']).to eq((Date.today + 1.day).strftime("%Y-%m-%d"))
                    
                    expect(assignment).to include('delivery_zone')
                    expect(assignment['delivery_zone']).to include('id')
                    expect(assignment['delivery_zone']['id']).to eq(@delivery_zones.first.id)
                    expect(assignment['delivery_zone']).to include('name')

                    expect(assignment).to include('restaurant')
                    expect(assignment['restaurant']).to include('id')
                    expect(assignment['restaurant']).to include('name')
                    expect(assignment['restaurant']).to include('meals')

                    assignment['restaurant']['meals'].each do | meal |
                        expect(meal).to include('id')
                        expect(meal).to include('name')
                    end
                end
            end
        end

        context 'when day and zone_id are both not passed' do
            it 'should return assignments' do
                get '/v1/assignments', params: { api_key: @restaurants.first.api_key }
                
                expect(response).to be_success
                body = JSON.parse(response.body)
                test_basic_response_structure(body)
                
                assignments = Assignment.where( restaurant_id: @restaurants.first )

                test_pagination(body, 1, 10, assignments.count)
                expect(body['data']['output'].length).to eq( assignments.length > 10 ? 10 : assignments.length )

                body['data']['output'].each_with_index do | assignment, index |
                    expect(assignment).to include('id')
                    expect(assignment).to include('date')
                    
                    expect(assignment).to include('delivery_zone')
                    expect(assignment['delivery_zone']).to include('id')
                    expect(assignment['delivery_zone']).to include('name')

                    expect(assignment).to include('restaurant')
                    expect(assignment['restaurant']).to include('id')
                    expect(assignment['restaurant']['id']).to eq(@restaurants.first.id)
                    expect(assignment['restaurant']).to include('name')
                    expect(assignment['restaurant']).to include('meals')

                    assignment['restaurant']['meals'].each do | meal |
                        expect(meal).to include('id')
                        expect(meal).to include('name')
                    end
                end
            end
        end

    end

end