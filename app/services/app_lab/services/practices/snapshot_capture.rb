module AppLab
  module Services
    module Practices
      class SnapshotCapture
        def capture
          items = BestPracticeItem.all
          checks = items.map(&:latest_check).compact

          passed = checks.count { |c| c.passed? }
          failed = checks.count { |c| c.failed? }
          na = checks.count { |c| c.na? }
          total = items.count

          overall = total > 0 ? (passed.to_f / (total - na) * 100).round(2) : 0

          category_scores = BestPracticeCategory.ordered.each_with_object({}) do |cat, hash|
            hash[cat.name] = cat.completion_percentage
          end

          BestPracticeSnapshot.create!(
            captured_at: Time.current,
            total_items: total,
            passed_count: passed,
            failed_count: failed,
            na_count: na,
            overall_score: overall,
            category_scores: category_scores
          )
        end
      end
    end
  end
end
