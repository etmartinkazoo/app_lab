module AppLab
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Install App Lab Center into the host application"

      def copy_initializer
        template "initializer.rb", "config/initializers/app_lab.rb"
      end

      def add_route
        route 'mount AppLab::Engine => "/app_lab"'
      end

      def copy_migrations
        migrations_source = AppLab::Engine.root.join("db/migrate")
        migrations_dest = Rails.root.join("db/app_lab_migrate")

        FileUtils.mkdir_p(migrations_dest)

        Dir.glob(migrations_source.join("*.rb")).sort.each do |migration|
          dest = migrations_dest.join(File.basename(migration))
          unless File.exist?(dest)
            FileUtils.cp(migration, dest)
            say_status :copy, "db/app_lab_migrate/#{File.basename(migration)}"
          end
        end
      end

      def run_migrations
        rake "db:migrate"
      end

      def seed_data
        rake "app_lab:db:seed"
      end

      def show_post_install
        say ""
        say "App Lab Center installed successfully!", :green
        say ""
        say "To use a separate database (recommended), add to config/database.yml:", :yellow
        say ""
        say "  production:"
        say "    primary:"
        say "      <<: *default"
        say "      database: your_app_production"
        say "    app_lab:"
        say "      adapter: sqlite3"
        say "      database: storage/production_app_lab.sqlite3"
        say "      migrations_paths: db/app_lab_migrate"
        say ""
        say "Then uncomment config.database and config.connects_to in"
        say "config/initializers/app_lab.rb"
        say ""
        say "Next steps:"
        say "  1. Configure config/initializers/app_lab.rb"
        say "  2. Set environment variables: GITHUB_TOKEN, ANTHROPIC_API_KEY"
        say "  3. Start your server and visit /app_lab"
        say ""
      end
    end
  end
end
