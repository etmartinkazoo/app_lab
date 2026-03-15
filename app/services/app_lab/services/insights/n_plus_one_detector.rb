module AppLab
  module Services
    module Insights
      class NPlusOneDetector < BaseDetector
        # Detects potential N+1 queries by analyzing controller/view patterns
        ASSOCIATION_PATTERN = /\.each\s+do\s+\|.*?\|.*?\.([\w]+)/m
        INCLUDES_PATTERN = /\.(includes|eager_load|preload)\(/

        def detect
          findings = []

          controller_files.each do |file|
            content = read_file(file)
            next unless content

            # Look for .each blocks that access associations without includes
            content.lines.each_with_index do |line, index|
              # Simple heuristic: look for collection iteration patterns
              if line.match?(/\.\w+\.each/) && !nearby_includes?(content, index)
                findings << {
                  title: "Potential N+1 query in #{relative_path(file)}:#{index + 1}",
                  description: "Collection iteration detected without apparent eager loading. Review for N+1 query patterns.",
                  file_path: relative_path(file),
                  line_number: index + 1,
                  code_snippet: extract_context(content, index),
                  suggested_fix: "Add .includes(:association) to the query to eager load associations and prevent N+1 queries."
                }
              end
            end
          end

          findings
        end

        private

        def nearby_includes?(content, line_index)
          lines = content.lines
          start = [line_index - 10, 0].max
          finish = [line_index + 2, lines.size - 1].min
          context = lines[start..finish].join
          context.match?(INCLUDES_PATTERN)
        end

        def extract_context(content, line_index, context_lines: 3)
          lines = content.lines
          start = [line_index - context_lines, 0].max
          finish = [line_index + context_lines, lines.size - 1].min
          lines[start..finish].join
        end
      end
    end
  end
end
