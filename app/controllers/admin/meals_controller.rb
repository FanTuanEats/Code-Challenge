class Admin::MealsController < ApplicationController
    def index
        @meals = Meal.all.order(:name)
    end
  
    def show
        @meal = Meal.find(params[:id])
    end

    def destroy
        Meal.find(params[:id]).destroy
        flash[:success] = "Meal deleted"
        redirect_to admin_meals_url
    end
end
  