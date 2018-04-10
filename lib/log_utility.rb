##
# This module is used to log to files.
module LogUtility

    def self.get_tracking_hash(input_string)
        Digest::MD5.hexdigest(input_string)
      end

    def self.log_ex(pre, ex, file = 'app', debug_info = nil)
        self.custom_logger(file).error(self.build_exception_log(ex, pre, debug_info))
        # Add any kind of alerts or notifiers here as needed
    end

    protected
    
    def self.custom_logger(file)
        logfile = "#{Rails.root}/log/#{file}.#{Rails.env}.log"
        @@custom_logger = Logger.new(logfile)
    end

    def self.build_exception_log(ex, where, debug_info)
        {
            when: self.get_log_datetime,
            what: ex.message,
            where: where,
            who: debug_info,
            how: (Rails.env.development? ? ex.backtrace.join("\n") : nil)
        }.to_json
    end

    def self.get_log_datetime
        Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
    end

end