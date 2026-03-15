module AppLab
  class Engine < ::Rails::Engine
    isolate_namespace AppLab

    engine_name "app_lab"

    # Autoload services
    config.autoload_paths << "#{root}/app/services"
    config.eager_load_paths << "#{root}/app/services"

    initializer "app_lab.assets" do |app|
      app.middleware.use(
        Rack::Static,
        urls: ["/app-lab-assets"],
        root: root.join("public").to_s,
        header_rules: [
          [:all, { "cache-control" => "public, max-age=31536000, immutable" }]
        ]
      )
    end

    # Copy migrations to host app on install
    initializer "app_lab.migrations" do |app|
      unless app.root.to_s.match?(root.to_s)
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    initializer "app_lab.inertia" do |app|
      ActiveSupport.on_load(:action_controller_base) do
        include InertiaRails::Controller
      end
    end

    initializer "app_lab.active_job" do
      ActiveSupport.on_load(:active_job) do
        # Job configuration for Solid Queue integration
      end
    end

    rake_tasks do
      load AppLab::Engine.root.join("lib/tasks/app_lab.rake")
    end

    config.generators do |g|
      g.test_framework :minitest
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "test/factories"
    end
  end
end
