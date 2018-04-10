class Admin::AssignmentsController < ApplicationController
    def index
        @assignments = Assignment.all.order(:date)
    end
  
    def show
        @assignment = Assignment.find(params[:id])
    end

    def destroy
        Assignment.find(params[:id]).destroy
        flash[:success] = "Delivery zone deleted"
        redirect_to admin_delivery_zones_url
    end
end
  