class Admin::RestrictRestaurantDaysController < ApplicationController

    def new
        @restaurant = Restaurant.find(params[:restaurant_id])
        @restrict_restaurant_day = @restaurant.restrict_restaurant_days.build
    end

    def create
        @restaurant = Restaurant.find(params[:restaurant_id])
        @restrict_restaurant_day = @restaurant.restrict_restaurant_days.build(restrict_restaurant_day_params)
        
        @restrict_restaurant_day = RestrictRestaurantDay.new(restrict_restaurant_day_params)
        if @restrict_restaurant_day.save
            redirect_to admin_restaurant_url(@restrict_restaurant_day.restaurant)
        else
            render 'new'
        end
    end

    def destroy
        RestrictRestaurantDay.find(params[:id]).destroy
        redirect_to admin_restaurant_url(params[:restaurant_id])
    end

    private

    def restrict_restaurant_day_params
        params.require(:restrict_restaurant_day).permit(:restaurant_id, :day)
    end
end
  