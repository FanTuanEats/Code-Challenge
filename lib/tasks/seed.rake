namespace :seed do 

    task api_keys: :environment do |t, args|
        puts
        puts 'Seeding API keys'
        puts

        u = User.where( name: Faker::Name.name ).first_or_create
        u.save!
        puts "Created user: #{u.name}"
        puts "Key: #{u.api_key}"

        puts
        puts 'Done!'
        puts
    end

    # Seed the database with fake data
    task chowbus: :environment do |t, args|
        puts
        puts 'Seeding chowbus app'
        puts

        (0..20).each do | restaurant_count |
            restaurant = Restaurant.new(
                name: Faker::Company.name,
            )
            restaurant.save!
        
            (0...(rand(1...20))).each do | meal_count |
                meal = Meal.new(
                    name: Faker::Food.unique.dish,
                    restaurant: restaurant
                )
                meal.save!
                meal.update_attributes!(
                    restaurant_id: restaurant.id
                )
            end
            Faker::Food.unique.clear
        end
        
        (0..5).each do | delivery_zone_count |
            delivery_zone = DeliveryZone.new(
                name: "Zone #{delivery_zone_count}"
            )
            delivery_zone.save!
        end

        # Assignment.assign_deliveries

        Restaurant.order("random()").limit(rand(5...10)).each do | r |
            days = []
            (0...(rand(1...3))).each do | day_count |
                day = rand(0...7)
                while days.include?(day)
                    day = rand(0...7)
                end
                days << day

                RestrictRestaurantDay.new(
                    restaurant_id: r.id,
                    day: day
                ).save!
            end
        end

        Restaurant.order("random()").limit(rand(5...10)).each do | r |
            DeliveryZone.order("random()").limit(rand(1...3)).each do | z |
                RestrictRestaurantDeliveryZone.new(
                    restaurant_id: r.id,
                    delivery_zone_id: z.id
                ).save!
            end
        end

        puts
        puts 'Done!'
        puts
    end

    task assignment: :environment do |t, args|
        Assignment.assign_deliveries_for_date_range(Date.today, 7)

        puts
        puts 'Done!'
        puts
    end
end