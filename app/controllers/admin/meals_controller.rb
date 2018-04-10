class Admin::MealsController < ApplicationController

    def new
        @restaurant = Restaurant.find(params[:restaurant_id])
        @meal = @restaurant.meals.build
    end

    def create
        @restaurant = Restaurant.find(params[:restaurant_id])
        @meal = @restaurant.meals.build(meal_params)
        
        @meal = Meal.new(meal_params)
        if @meal.save
            redirect_to admin_restaurant_url(@meal.restaurant)
        else
            render 'new'
        end
    end

    def index
        @meals = Meal.all.order(:name)
    end
  
    def show
        @meal = Meal.find(params[:id])
    end

    def edit
        @meal = Meal.find(params[:id])
        redirect_to admin_restaurants_url if @meal.nil?
    end

    def update
        @meal = Meal.find(params[:id])
        if @meal.update_attributes(meal_params)
            render 'show'
        else
            render 'edit'
        end
    end

    def destroy
        Meal.find(params[:id]).destroy
        flash[:success] = "Meal deleted"
        redirect_to admin_meals_url
    end

    private

    def meal_params
        params.require(:meal).permit(:name, :restaurant_id)
    end
end
  