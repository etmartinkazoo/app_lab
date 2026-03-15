module AppLab
  class DailyCommitScanJob < ApplicationJob
    queue_as :app_lab

    def perform(date: Date.current)
      return unless AppLab.configuration.github_enabled

      report = DailyReport.find_or_initialize_by(date: date)
      report.update!(status: :processing)

      commits = Services::Github::CommitFetcher.new.fetch(date: date)
      report.update!(raw_commits: commits)

      commits.each do |commit_data|
        report.commit_entries.find_or_create_by!(sha: commit_data[:sha]) do |entry|
          entry.message = commit_data[:message]
          entry.author = commit_data[:author]
          entry.is_breaking = commit_data[:message].match?(/breaking|BREAKING/i)
        end
      end

      report.update!(status: :completed)

      GenerateSummaryJob.perform_later(report.id)
    rescue => e
      report&.update(status: :failed)
      raise
    end
  end
end
