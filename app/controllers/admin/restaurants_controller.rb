class Admin::RestaurantsController < ApplicationController
    def index
        @restaurants = Restaurant.all.order(:name)
    end
  
    def show
        @restaurant = Restaurant.find(params[:id])
        redirect_to admin_restaurants_url if @restaurant.nil?
    end

    def destroy
        Restaurant.find(params[:id]).destroy
        flash[:success] = "Restaurant deleted"
        redirect_to admin_restaurants_url
    end
end
  