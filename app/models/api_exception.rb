##
# This class should be used to hold debug information for an exception.
class ApiException < StandardError
    attr :major_code

    def initialize(params = {})
        @@major_code = params[:major_code] || raise("You must specify a major code when raising an API exception")
    end

    def code
        @@major_code
    end
    def major_code
        @@major_code
    end
end