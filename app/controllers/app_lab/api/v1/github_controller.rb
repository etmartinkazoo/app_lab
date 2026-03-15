module AppLab
  module Api
    module V1
      class GithubController < BaseController
        def commits
          date = Date.parse(params[:date] || Date.current.to_s)
          report = DailyReport.find_by(date: date)

          if report
            render json: {
              date: report.date,
              commits: report.commit_entries.map { |c|
                { sha: c.sha, message: c.message, author: c.author, category: c.effective_category }
              }
            }
          else
            render json: { error: "No report for #{date}" }, status: :not_found
          end
        end

        def sync
          DailyCommitScanJob.perform_later
          render json: { status: "queued" }
        end

        def summary
          report = DailyReport.find_by!(date: params[:date])
          render json: {
            date: report.date,
            summary: report.summary,
            status: report.status,
            reviewed: report.reviewed?
          }
        end

        def update_summary
          report = DailyReport.find_by!(date: params[:date])
          report.update!(human_summary: params[:summary])
          render json: { status: "updated" }
        end
      end
    end
  end
end
