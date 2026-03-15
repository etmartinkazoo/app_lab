module AppLab
  class GenerateSummaryJob < ApplicationJob
    queue_as :app_lab

    def perform(report_id)
      report = DailyReport.find(report_id)
      return unless report.completed?

      summary = Services::Ai::SummaryGenerator.new.generate(report)
      report.update!(ai_summary: summary)

      # Categorize commits via AI
      report.commit_entries.where(ai_category: nil).find_each do |entry|
        category = Services::Ai::CommitCategorizer.new.categorize(entry)
        entry.update!(ai_category: category)
      end

      SendDigestJob.perform_later(report.id)
    end
  end
end
