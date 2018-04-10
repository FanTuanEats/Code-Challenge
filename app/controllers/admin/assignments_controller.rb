class Admin::AssignmentsController < ApplicationController
    def index
        @assignment_date = params[:date] ? Date.strptime(params[:date], "%Y-%m-%d") : Date.today

        @assignments = Assignment.where(date: @assignment_date)

        unless params[:date]
            @past_assignments = Assignment.in_the_past_week
            @future_assignments = Assignment.in_the_next_week
        end
    end
  
    def show
        @assignment = Assignment.find(params[:id])
    end

    def destroy
        Assignment.find(params[:id]).destroy
        redirect_to admin_delivery_zones_url
    end

    def generate
        redirect_to admin_assignments_path unless params[:date]
        Assignment.assign_deliveries_for_day(Date.strptime(params[:date], "%Y-%m-%d"))
        redirect_to admin_assignments_path(date: params[:date])
    end
end
  