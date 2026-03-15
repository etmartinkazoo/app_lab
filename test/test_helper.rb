ENV["RAILS_ENV"] = "test"

require_relative "dummy/config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Load schema
  schema_path = AppLab::Engine.root.join("db", "app_lab_schema.rb")
  load(schema_path) if File.exist?(schema_path)
end
