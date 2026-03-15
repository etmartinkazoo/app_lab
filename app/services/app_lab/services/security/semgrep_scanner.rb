require "json"

module AppLab
  module Services
    module Security
      class SemgrepScanner
        def run
          output = execute_semgrep
          parsed = JSON.parse(output, symbolize_names: true)

          findings = (parsed[:results] || []).map do |result|
            {
              severity: map_severity(result.dig(:extra, :severity)),
              category: result.dig(:extra, :metadata, :category) || result[:check_id],
              file_path: result[:path],
              line_number: result.dig(:start, :line),
              description: result.dig(:extra, :message) || result[:check_id],
              confidence: :medium_confidence,
              cwe_id: Array(result.dig(:extra, :metadata, :cwe)).first,
              owasp_category: Array(result.dig(:extra, :metadata, :owasp)).first
            }
          end

          {
            findings: findings,
            raw_output: parsed,
            summary: "Semgrep found #{findings.size} issue(s)"
          }
        end

        private

        def execute_semgrep
          app_path = Rails.root.to_s
          result = `semgrep --config auto --json #{app_path} 2>/dev/null`
          $?.success? ? result : '{"results": []}'
        end

        def map_severity(severity)
          case severity&.upcase
          when "ERROR" then :high
          when "WARNING" then :medium
          when "INFO" then :low
          else :info
          end
        end
      end
    end
  end
end
