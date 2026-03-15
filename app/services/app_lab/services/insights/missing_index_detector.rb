module AppLab
  module Services
    module Insights
      class MissingIndexDetector < BaseDetector
        def detect
          findings = []
          schema_path = File.join(app_path, "db", "schema.rb")
          schema = read_file(schema_path)
          return findings unless schema

          # Extract foreign keys and check for indexes
          schema.scan(/t\.\w+\s+"(\w+_id)"/) do |match|
            column = match[0]
            # Check if there's an index for this column
            unless schema.match?(/index.*#{Regexp.escape(column)}/)
              findings << {
                title: "Missing index on #{column}",
                description: "Foreign key column '#{column}' does not have a database index. This can cause slow queries on joins and lookups.",
                file_path: "db/schema.rb",
                line_number: nil,
                code_snippet: nil,
                suggested_fix: "Add a migration: add_index :table_name, :#{column}"
              }
            end
          end

          findings
        end
      end
    end
  end
end
