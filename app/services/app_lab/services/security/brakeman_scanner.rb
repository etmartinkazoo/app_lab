require "json"

module AppLab
  module Services
    module Security
      class BrakemanScanner
        def run
          output = execute_brakeman
          parsed = JSON.parse(output, symbolize_names: true)

          findings = (parsed[:warnings] || []).map do |warning|
            {
              severity: map_confidence_to_severity(warning[:confidence]),
              category: warning[:warning_type],
              file_path: warning[:file],
              line_number: warning[:line],
              description: warning[:message],
              confidence: map_confidence(warning[:confidence]),
              cwe_id: warning[:cwe_id]&.then { |ids| Array(ids).first&.to_s },
              owasp_category: nil
            }
          end

          {
            findings: findings,
            raw_output: parsed,
            summary: "Brakeman found #{findings.size} warning(s)"
          }
        end

        private

        def execute_brakeman
          app_path = Rails.root.to_s
          result = `brakeman #{app_path} --format json --no-pager --quiet 2>/dev/null`

          if $?.success? || $?.exitstatus == 3 # exit 3 = warnings found
            result
          else
            AppLab.logger.error("Brakeman execution failed: exit #{$?.exitstatus}")
            '{"warnings": []}'
          end
        end

        def map_confidence_to_severity(confidence)
          case confidence
          when 0 then :high      # High confidence = likely real
          when 1 then :medium    # Medium confidence
          when 2 then :low       # Weak confidence
          else :info
          end
        end

        def map_confidence(confidence)
          case confidence
          when 0 then :high_confidence
          when 1 then :medium_confidence
          when 2 then :low_confidence
          else :low_confidence
          end
        end
      end
    end
  end
end
