module AppLab
  class InsightScanJob < ApplicationJob
    queue_as :app_lab

    def perform
      return unless AppLab.configuration.insights_enabled

      rules = if AppLab.configuration.insights_rules == :all
        InsightRule.enabled
      else
        InsightRule.enabled.where(name: AppLab.configuration.insights_rules)
      end

      rules.find_each do |rule|
        detector = Services::Insights::DetectorFactory.build(rule)
        findings = detector.detect

        findings.each do |f|
          InsightFinding.find_or_create_by!(
            insight_rule: rule,
            file_path: f[:file_path],
            line_number: f[:line_number],
            status: :open
          ) do |finding|
            finding.title = f[:title]
            finding.description = f[:description]
            finding.code_snippet = f[:code_snippet]
            finding.suggested_fix = f[:suggested_fix]
            finding.detected_at = Time.current
          end
        end
      end

      # Record metrics
      Services::Insights::MetricsCollector.new.collect
    end
  end
end
