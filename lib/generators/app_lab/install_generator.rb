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

      def show_post_install
        say ""
        say "App Lab Center files installed!", :green
        say ""
        say "Complete setup:", :yellow
        say ""
        say "  1. Add the app_lab database to config/database.yml for each environment:"
        say ""
        say "     production:"
        say "       primary:"
        say "         <<: *default"
        say "         database: your_app_production"
        say "       app_lab:"
        say "         adapter: sqlite3"
        say "         database: storage/production_app_lab.sqlite3"
        say "         migrations_paths: db/app_lab_migrate"
        say ""
        say "  2. Uncomment config.database and config.connects_to in"
        say "     config/initializers/app_lab.rb"
        say ""
        say "  3. Run migrations and seed:"
        say "     rails db:create rails db:migrate"
        say "     rails app_lab:db:seed"
        say ""
        say "  4. Set environment variables: GITHUB_TOKEN, ANTHROPIC_API_KEY"
        say ""
        say "  5. Start your server and visit /app_lab"
        say ""
      end
    end
  end
end
