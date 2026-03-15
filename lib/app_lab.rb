require "app_lab/version"
require "app_lab/configuration"
require "app_lab/engine"

module AppLab
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
      configuration.validate!
    end

    def reset_configuration!
      @configuration = Configuration.new
    end

    def logger
      @logger ||= ActiveSupport::TaggedLogging.new(Rails.logger).tagged("AppLab")
    end

    def connects_to
      configuration.connects_to
    end

    def enabled?
      configuration.enabled
    end
  end
end
