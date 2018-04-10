class ApplicationController < ActionController::Base
    include ValidationHelper

    protected
    def validate_params_required (parameter_list)
        parameter_list.each do |parameter|
            ValidationHelper.validate_params_required(parameter, params)
        end
    end

    def validate_id (object_class, id)
        ValidationHelper.validate_uuid_format(id)
        raise ApiException.new(
            major_code: StatusCodes::BAD_REQUEST
        ), 'Invalid ID: ' + id unless object_class.exists?(id)
    end
end
