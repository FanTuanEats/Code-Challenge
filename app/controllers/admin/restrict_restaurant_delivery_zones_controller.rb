class Admin::RestrictRestaurantDeliveryZonesController < ApplicationController

    def new
        @restaurant = Restaurant.find(params[:restaurant_id])

        restricted_zones = @restaurant.restrict_restaurant_delivery_zones.any? ? DeliveryZone.where("id not in (?)", @restaurant.restrict_restaurant_delivery_zones.pluck(:delivery_zone_id)) : DeliveryZone.all
        @delivery_zones = restricted_zones.order("name asc").collect{|dz| [dz.name, dz.id]}

        @restrict_restaurant_delivery_zone = @restaurant.restrict_restaurant_delivery_zones.build
    end

    def create
        @restaurant = Restaurant.find(params[:restaurant_id])
        @restrict_restaurant_delivery_zone = @restaurant.restrict_restaurant_delivery_zones.build(restrict_restaurant_delivery_zone_params)
        
        @restrict_restaurant_delivery_zone = RestrictRestaurantDeliveryZone.new(restrict_restaurant_delivery_zone_params)
        if @restrict_restaurant_delivery_zone.save
            redirect_to admin_restaurant_url(@restrict_restaurant_delivery_zone.restaurant)
        else
            render 'new'
        end
    end

    def edit
        @restrict_restaurant_delivery_zone = RestrictRestaurantDeliveryZone.find(params[:id])
        redirect_to admin_restaurants_url if @restrict_restaurant_delivery_zone.nil?
    end

    def update
        @restrict_restaurant_delivery_zone = RestrictRestaurantDeliveryZone.find(params[:id])
        if @restrict_restaurant_delivery_zone.update_attributes(restrict_restaurant_delivery_zone_params)
            render 'show'
        else
            render 'edit'
        end
    end

    def destroy
        RestrictRestaurantDeliveryZone.find(params[:id]).destroy
        redirect_to admin_restaurant_url(params[:restaurant_id])
    end

    private

    def restrict_restaurant_delivery_zone_params
        params.require(:restrict_restaurant_delivery_zone).permit(:restaurant_id, :delivery_zone_id)
    end
end
  