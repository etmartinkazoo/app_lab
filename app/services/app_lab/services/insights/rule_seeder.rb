module AppLab
  module Services
    module Insights
      class RuleSeeder
        CATEGORIES = [
          {
            name: "Performance",
            icon: "zap",
            description: "Performance-related insights",
            rules: [
              { name: "n_plus_one_queries", description: "Detect potential N+1 query patterns", severity: :high, effort_estimate: :medium_effort },
              { name: "missing_indexes", description: "Detect foreign key columns without database indexes", severity: :high, effort_estimate: :quick },
              { name: "large_files", description: "Detect Ruby files exceeding 300 lines", severity: :low, effort_estimate: :medium_effort }
            ]
          },
          {
            name: "Maintainability",
            icon: "wrench",
            description: "Code maintainability insights",
            rules: [
              { name: "todo_comments", description: "Track TODO/FIXME/HACK comments as technical debt", severity: :low, effort_estimate: :quick },
              { name: "dead_code", description: "Detect potentially unused private methods", severity: :medium, effort_estimate: :quick }
            ]
          }
        ].freeze

        def self.seed!
          CATEGORIES.each do |cat_data|
            rules = cat_data.delete(:rules)
            category = AppLab::InsightCategory.find_or_create_by!(name: cat_data[:name]) do |c|
              c.assign_attributes(cat_data)
            end

            rules.each do |rule_data|
              category.insight_rules.find_or_create_by!(name: rule_data[:name]) do |rule|
                rule.assign_attributes(rule_data)
              end
            end
          end
        end
      end
    end
  end
end
