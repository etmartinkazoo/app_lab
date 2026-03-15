module AppLab
  module Services
    module Insights
      class TodoCommentDetector < BaseDetector
        PATTERNS = /\b(TODO|FIXME|HACK|XXX|OPTIMIZE)\b/i

        def detect
          findings = []

          ruby_files.each do |file|
            content = read_file(file)
            next unless content

            content.lines.each_with_index do |line, index|
              next unless line.match?(PATTERNS)

              match = line.match(PATTERNS)
              findings << {
                title: "#{match[1].upcase} comment in #{relative_path(file)}:#{index + 1}",
                description: line.strip,
                file_path: relative_path(file),
                line_number: index + 1,
                code_snippet: line.strip,
                suggested_fix: "Address this #{match[1].upcase} or create a tracked issue for it."
              }
            end
          end

          findings
        end
      end
    end
  end
end
