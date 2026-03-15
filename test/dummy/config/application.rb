require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)
require "app_lab"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.eager_load = false
    config.active_job.queue_adapter = :test
    config.root = File.expand_path("../..", __FILE__)
  end
end
