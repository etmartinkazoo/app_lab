module AppLab
  module Services
    module Security
      class BundleAuditScanner
        def run
          output = execute_bundle_audit
          findings = parse_output(output)

          {
            findings: findings,
            raw_output: { text: output },
            summary: "Bundle audit found #{findings.size} vulnerable gem(s)"
          }
        end

        private

        def execute_bundle_audit
          `bundle-audit check --update 2>/dev/null`
        end

        def parse_output(output)
          findings = []
          current = nil

          output.each_line do |line|
            line = line.strip
            if line.start_with?("Name:")
              current = { category: "Vulnerable Dependency" }
              current[:description] = "Gem: #{line.sub('Name: ', '')}"
            elsif line.start_with?("Version:") && current
              current[:description] += " (#{line.strip})"
            elsif line.start_with?("Advisory:") && current
              current[:cwe_id] = line.sub("Advisory: ", "").strip
            elsif line.start_with?("Criticality:") && current
              current[:severity] = map_severity(line.sub("Criticality: ", "").strip)
            elsif line.start_with?("Title:") && current
              current[:description] += " - #{line.sub('Title: ', '')}"
            elsif line.empty? && current
              current[:severity] ||= :medium
              current[:confidence] = :high_confidence
              current[:file_path] = "Gemfile.lock"
              current[:line_number] = nil
              current[:owasp_category] = "A06:2021 - Vulnerable and Outdated Components"
              findings << current
              current = nil
            end
          end

          findings << current if current
          findings
        end

        def map_severity(criticality)
          case criticality&.downcase
          when "critical" then :critical
          when "high" then :high
          when "medium" then :medium
          when "low" then :low
          else :medium
          end
        end
      end
    end
  end
end
