module AppLab
  module Services
    module Insights
      class MetricsCollector
        def collect
          record("open_findings", InsightFinding.where(status: :open).count)
          record("total_ruby_files", Dir.glob(File.join(Rails.root, "app", "**", "*.rb")).count)
          record("total_lines_of_code", count_lines_of_code)
          record("open_security_findings", SecurityFinding.actionable.count)
          record("best_practice_score", latest_practice_score)
        end

        private

        def record(name, value)
          InsightMetric.create!(
            metric_name: name,
            metric_value: value,
            recorded_at: Time.current
          )
        end

        def count_lines_of_code
          Dir.glob(File.join(Rails.root, "app", "**", "*.rb")).sum do |file|
            File.readlines(file).count { |line| line.strip.present? && !line.strip.start_with?("#") }
          rescue
            0
          end
        end

        def latest_practice_score
          BestPracticeSnapshot.recent.first&.overall_score || 0
        end
      end
    end
  end
end
