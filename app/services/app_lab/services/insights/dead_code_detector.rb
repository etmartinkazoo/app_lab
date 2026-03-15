module AppLab
  module Services
    module Insights
      class DeadCodeDetector < BaseDetector
        def detect
          # Basic detection: find private methods that aren't called within the same file
          findings = []

          ruby_files.each do |file|
            content = read_file(file)
            next unless content

            private_methods = extract_private_methods(content)
            private_methods.each do |method_name, line_number|
              # Check if method is referenced elsewhere in the file (besides definition)
              references = content.scan(/\b#{Regexp.escape(method_name)}\b/).size
              if references <= 1 # Only the definition itself
                findings << {
                  title: "Potentially unused method '#{method_name}' in #{relative_path(file)}",
                  description: "Private method '#{method_name}' appears to be unused within its file. Verify it's not called via metaprogramming before removing.",
                  file_path: relative_path(file),
                  line_number: line_number,
                  code_snippet: nil,
                  suggested_fix: "Remove the method if confirmed unused, or add a comment explaining its usage."
                }
              end
            end
          end

          findings
        end

        private

        def extract_private_methods(content)
          methods = []
          in_private = false

          content.lines.each_with_index do |line, index|
            if line.strip == "private"
              in_private = true
              next
            end

            if in_private && line.match?(/^\s*def\s+(\w+)/)
              method_name = line.match(/^\s*def\s+(\w+)/)[1]
              methods << [method_name, index + 1]
            end
          end

          methods
        end
      end
    end
  end
end
