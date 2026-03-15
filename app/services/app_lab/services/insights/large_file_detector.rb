module AppLab
  module Services
    module Insights
      class LargeFileDetector < BaseDetector
        MAX_LINES = 300

        def detect
          findings = []

          ruby_files.each do |file|
            content = read_file(file)
            next unless content

            line_count = content.lines.count
            next unless line_count > MAX_LINES

            findings << {
              title: "Large file: #{relative_path(file)} (#{line_count} lines)",
              description: "This file has #{line_count} lines, exceeding the #{MAX_LINES} line threshold. Consider extracting classes or modules.",
              file_path: relative_path(file),
              line_number: 1,
              code_snippet: nil,
              suggested_fix: "Consider splitting this file into smaller, focused classes or modules using the Single Responsibility Principle."
            }
          end

          findings
        end
      end
    end
  end
end
