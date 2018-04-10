class Admin::DeliveryZonesController < ApplicationController

    def new
        @delivery_zone = DeliveryZone.new    
    end

    def create
        @delivery_zone = DeliveryZone.new(delivery_zone_params)
        if @delivery_zone.save
            redirect_to admin_delivery_zones_url
        else
            render 'new'
        end
    end

    def index
        @delivery_zones = DeliveryZone.all.order(:name)
    end
  
    def show
        @delivery_zone = DeliveryZone.find(params[:id])
    end

    def edit
        @delivery_zone = DeliveryZone.find(params[:id])
        redirect_to admin_restaurants_url if @delivery_zone.nil?
    end

    def update
        @delivery_zone = DeliveryZone.find(params[:id])
        if @delivery_zone.update_attributes(delivery_zone_params)
            render 'show'
        else
            render 'edit'
        end
    end

    def destroy
        DeliveryZone.find(params[:id]).destroy
        redirect_to admin_delivery_zones_url
    end

    private

    def delivery_zone_params
        params.require(:delivery_zone).permit(:name)
    end
end
  