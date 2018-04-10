class Admin::RestaurantsController < ApplicationController

    def new
        @restaurant = Restaurant.new    
    end

    def create
        @restaurant = Restaurant.new(restaurant_params)
        if @restaurant.save
            redirect_to admin_restaurants_url
        else
            render 'new'
        end
    end

    def index
        @restaurants = Restaurant.all.order(:name)
    end
  
    def show
        @restaurant = Restaurant.find(params[:id])
        redirect_to admin_restaurants_url if @restaurant.nil?
    end

    def edit
        @restaurant = Restaurant.find(params[:id])
        redirect_to admin_restaurants_url if @restaurant.nil?
    end

    def update
        @restaurant = Restaurant.find(params[:id])
        if @restaurant.update_attributes(restaurant_params)
            render 'show'
        else
            render 'edit'
        end
    end

    def destroy
        Restaurant.find(params[:id]).destroy
        flash[:success] = "Restaurant deleted"
        redirect_to admin_restaurants_url
    end

    private

    def restaurant_params
        params.require(:restaurant).permit(:name)
    end
end
  