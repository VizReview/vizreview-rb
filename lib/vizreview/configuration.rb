module VizReview
  class Configuration
    attr_accessor :api_url, :token, :log_level, :default_viewport

    def initialize(api_url:)
      @api_url = api_url
      @log_level = :fatal
      @default_viewport = nil
    end
  end
end
