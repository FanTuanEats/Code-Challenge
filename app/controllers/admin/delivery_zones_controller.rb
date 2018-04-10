class Admin::DeliveryZonesController < ApplicationController
    def index
        @delivery_zones = DeliveryZone.all.order(:name)
    end
  
    def show
        @delivery_zone = DeliveryZone.find(params[:id])
    end

    def destroy
        DeliveryZone.find(params[:id]).destroy
        flash[:success] = "Delivery zone deleted"
        redirect_to admin_delivery_zones_url
    end
end
  