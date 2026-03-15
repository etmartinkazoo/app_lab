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
        say "Next steps:"
        say "  1. Configure config/initializers/app_lab.rb"
        say "  2. Set environment variables: GITHUB_TOKEN, ANTHROPIC_API_KEY"
        say "  3. Run `npm run build` inside the app_lab gem directory to build frontend assets"
        say "  4. Start your server and visit /app_lab"
        say ""
      end
    end
  end
end
