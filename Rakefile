require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"

APP_RAKEFILE = File.expand_path("test/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake" if File.exist?(APP_RAKEFILE)

load "rails/tasks/statistics.rake" if defined?(Rails)

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
end

task default: :test
