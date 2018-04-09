##
# This class contains methods that are uniform among creating, reading, updating, and deleting resources.
class ResourceController < ApplicationController
    include PaginationHelper

    # index - This returns a page of results
    # GET /{plural_resource_name}
    def index
        resources = resource_class.joins(join_tables).where(query_params.delete_if { |k, v| v.empty? }).where(filter_params)
        @meta = {
            order: params[:order],
            pagination: pagination(resources.count)
        }
        @output = resources.order(order_param).offset(offset).limit(items_per_page)
        render "layouts/api"
    end

    def join_tables
        nil
    end

    private
    def order_param
        params[:order] || 'created_at desc, id asc'
    end

    def get_resource
        instance_variable_get("@#{resource_name}")
    end

    # Returns the allowed parameters for pagination
    def page_params
        params.permit(:page, :page_size, :order)
    end
    
    # Returns the allowed parameters for searching
    # Override this method in each API controller
    # to permit additional parameters to search on
    def query_params
        {}
    end

    # The resource class based on the controller
    def resource_class
        @resource_class ||= resource_name.classify.constantize
    end

    # The singular name for the resource class based on the controller
    def resource_name
        @resource_name ||= self.controller_name.singularize
    end

    def resource_params
        @resource_params ||= self.send("#{resource_name}_params")
    end
    
    def set_resource(resource = nil)
        resource ||= resource_class.find(params[:id])
        instance_variable_set("@#{resource_name}", resource)
    end
end