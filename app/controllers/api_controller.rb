##
# This class contains methods pertaining to returning API results as well as handling errors.
# This also does the authentication for the `api_key`.
class ApiController < ResourceController

    before_action :cors
    before_action :authenticate
    
    rescue_from StandardError do |exception|
        handle_rescue(exception)
    end

    protected

    # Authenticates the api_key parameter
    def authenticate
        validate_params_required ['api_key']
        ValidationHelper.validate_uuid_format(params['api_key'])
        @current_user = Restaurant.find_by(api_key: params['api_key'])
        raise ApiException.new(
            major_code: StatusCodes::FORBIDDEN
        ), 'Invalid API Key: ' + params['api_key'] unless @current_user
    end

    ##
    # Allows for cross domain calling of the API
    def cors
        response.headers['Access-Control-Allow-Credentials'] = "true"
        response.headers['Access-Control-Allow-Origin'] = '*'
        response.headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        response.headers['Access-Control-Request-Method'] = '*'
        response.headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end

    ##
    # Handles any thrown exceptions. Logs the exceptions and returns a standardized error message.
    def handle_rescue(exception)
        LogUtility.log_ex("[#{request.env['PATH_INFO']}]", exception, 'api.errors', get_log_constants)
        @meta = {
            code: exception.code,
            message: exception.message
        }
        @output = nil
        render 'layouts/api', content_type: 'application/json'
    end

    ##
    # Gets information for logs
    def get_log_constants
        {
            url: request.original_url.to_s,
            verb: request.method,
            parameters: params
        }
    end

end