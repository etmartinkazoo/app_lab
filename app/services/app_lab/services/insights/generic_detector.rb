module AppLab
  module Services
    module Insights
      class GenericDetector < BaseDetector
        def detect
          return [] unless rule.detection_logic.present?

          # Execute the detection logic as a regex pattern match
          pattern = Regexp.new(rule.detection_logic)
          findings = []

          ruby_files.each do |file|
            content = read_file(file)
            next unless content

            content.lines.each_with_index do |line, index|
              if line.match?(pattern)
                findings << {
                  title: "#{rule.name}: match in #{relative_path(file)}:#{index + 1}",
                  description: rule.description,
                  file_path: relative_path(file),
                  line_number: index + 1,
                  code_snippet: line.strip,
                  suggested_fix: nil
                }
              end
            end
          end

          findings
        end
      end
    end
  end
end
