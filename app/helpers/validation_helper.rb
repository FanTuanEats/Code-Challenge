##
# This class contains methods to validate parameters. Any failed validations will throw an API friendly exception.
module ValidationHelper

    def self.validate_params_required(*args, params)
        args.each do |name|
            name = name.instance_of?(Array) ? name.first : name
            raise ApiException.new(
                major_code: StatusCodes::BAD_REQUEST
            ), 'Required parameter missing: ' + name unless !params[name].nil? && !params[name].blank?
        end
    end

    def self.validate_uuid_format(uuid)
        uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
        raise ApiException.new(
            major_code: StatusCodes::BAD_REQUEST
        ), 'Invalid UUID: ' + uuid unless uuid_regex.match(uuid.to_s.downcase)
    end

end