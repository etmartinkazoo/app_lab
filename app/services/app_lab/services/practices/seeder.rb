module AppLab
  module Services
    module Practices
      class Seeder
        CATEGORIES = [
          {
            name: "Security",
            icon: "shield",
            display_order: 1,
            description: "Application security best practices",
            items: [
              { name: "HTTPS enforcement", verification_type: :automated, is_critical: true, weight: 3,
                automation_rule: { "type" => "config_value", "file" => "config/environments/production.rb", "pattern" => "force_ssl\\s*=\\s*true" },
                description: "Ensure all traffic is served over HTTPS in production" },
              { name: "Secure headers", verification_type: :automated, weight: 2,
                automation_rule: { "type" => "gem_present", "gem_name" => "secure_headers" },
                description: "Security headers gem is installed and configured" },
              { name: "Encrypted credentials", verification_type: :automated, is_critical: true, weight: 3,
                automation_rule: { "type" => "file_exists", "path" => "config/credentials.yml.enc" },
                description: "Rails encrypted credentials are in use" },
              { name: "CSP policy", verification_type: :manual, weight: 2,
                description: "Content Security Policy is configured and appropriate" },
              { name: "CSRF protection", verification_type: :automated, is_critical: true, weight: 3,
                automation_rule: { "type" => "config_value", "file" => "app/controllers/application_controller.rb", "pattern" => "protect_from_forgery" },
                description: "CSRF protection is enabled in ApplicationController" }
            ]
          },
          {
            name: "Performance",
            icon: "zap",
            display_order: 2,
            description: "Performance optimization best practices",
            items: [
              { name: "Database indexing", verification_type: :manual, weight: 3,
                description: "All frequently queried columns have appropriate indexes" },
              { name: "Caching strategy", verification_type: :manual, weight: 2,
                description: "Application has a defined caching strategy" },
              { name: "N+1 query prevention", verification_type: :automated, weight: 3,
                automation_rule: { "type" => "gem_present", "gem_name" => "bullet" },
                description: "Bullet gem is installed for N+1 query detection" },
              { name: "CDN usage", verification_type: :manual, weight: 1,
                description: "Static assets are served via CDN" },
              { name: "Background jobs for heavy work", verification_type: :automated, weight: 2,
                automation_rule: { "type" => "directory_exists", "path" => "app/jobs" },
                description: "Background job infrastructure is in place" }
            ]
          },
          {
            name: "Code Quality",
            icon: "code",
            display_order: 3,
            description: "Code quality and testing best practices",
            items: [
              { name: "Linting setup", verification_type: :automated, weight: 2,
                automation_rule: { "type" => "file_exists", "path" => ".rubocop.yml" },
                description: "RuboCop is configured for consistent code style" },
              { name: "Test coverage > 80%", verification_type: :manual, is_critical: true, weight: 3,
                description: "Test coverage meets the 80% threshold" },
              { name: "CI/CD pipeline", verification_type: :manual, is_critical: true, weight: 3,
                description: "Continuous integration and deployment pipeline is configured" },
              { name: "Code review process", verification_type: :manual, weight: 2,
                description: "All code changes go through pull request review" }
            ]
          },
          {
            name: "Architecture",
            icon: "layers",
            display_order: 4,
            description: "Application architecture best practices",
            items: [
              { name: "Service objects", verification_type: :automated, weight: 2,
                automation_rule: { "type" => "directory_exists", "path" => "app/services" },
                description: "Service object pattern is used for business logic" },
              { name: "Background job setup", verification_type: :automated, weight: 2,
                automation_rule: { "type" => "gem_present", "gem_name" => "solid_queue" },
                description: "Background job framework is configured" },
              { name: "API versioning", verification_type: :manual, weight: 1,
                description: "API endpoints are properly versioned" },
              { name: "Structured logging", verification_type: :manual, weight: 2,
                description: "Application uses structured, queryable logging" }
            ]
          },
          {
            name: "Operations",
            icon: "monitor",
            display_order: 5,
            description: "Operational readiness best practices",
            items: [
              { name: "Health check endpoint", verification_type: :manual, is_critical: true, weight: 3,
                description: "Application exposes a health check endpoint" },
              { name: "Error tracking", verification_type: :manual, is_critical: true, weight: 3,
                description: "Error tracking service is configured (Sentry, Honeybadger, etc.)" },
              { name: "Monitoring", verification_type: :manual, weight: 2,
                description: "Application monitoring is in place" },
              { name: "Database backups", verification_type: :manual, is_critical: true, weight: 3,
                description: "Automated database backups are configured and tested" }
            ]
          },
          {
            name: "Dependencies",
            icon: "package",
            display_order: 6,
            description: "Dependency management best practices",
            items: [
              { name: "No outdated gems", verification_type: :manual, weight: 2,
                description: "All gems are reasonably up-to-date" },
              { name: "No known vulnerabilities", verification_type: :automated, weight: 3, is_critical: true,
                automation_rule: { "type" => "gem_present", "gem_name" => "bundler-audit" },
                description: "bundler-audit is configured for vulnerability detection" },
              { name: "Lockfile committed", verification_type: :automated, weight: 2,
                automation_rule: { "type" => "file_exists", "path" => "Gemfile.lock" },
                description: "Gemfile.lock is committed to version control" }
            ]
          }
        ].freeze

        def self.seed!
          CATEGORIES.each do |cat_data|
            items = cat_data.delete(:items)
            category = AppLab::BestPracticeCategory.find_or_create_by!(name: cat_data[:name]) do |c|
              c.assign_attributes(cat_data)
            end

            items.each do |item_data|
              category.best_practice_items.find_or_create_by!(name: item_data[:name]) do |item|
                item.assign_attributes(item_data)
              end
            end
          end
        end
      end
    end
  end
end
