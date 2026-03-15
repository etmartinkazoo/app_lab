require_relative "lib/app_lab/version"

Gem::Specification.new do |spec|
  spec.name        = "app_lab"
  spec.version     = AppLab::VERSION
  spec.authors     = ["Brem"]
  spec.summary     = "A comprehensive daily dashboard engine for Rails applications"
  spec.description = "Rails Engine providing GitHub commit intelligence, security monitoring, best practices checklists, and performance insights for Rails applications."
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.2.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib,public}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0", "< 9.0"
  spec.add_dependency "inertia_rails", "~> 3.0"
  spec.add_dependency "solid_queue", "~> 1.0"
  spec.add_dependency "ransack", "~> 4.0"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "factory_bot_rails", "~> 6.0"
  spec.add_development_dependency "sqlite3", "~> 2.0"
end
