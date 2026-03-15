module AppLab
  class DailyReportsController < ApplicationController
    def index
      reports = DailyReport.recent.page(params[:page])
      render_inertia "DailyReports/Index", props: {
        reports: reports.map { |r| serialize(r) },
        pagination: pagination_props(reports)
      }
    end

    def show
      report = DailyReport.find(params[:id])
      render_inertia "DailyReports/Show", props: {
        report: serialize(report),
        commits: report.commit_entries.map { |c| serialize_commit(c) }
      }
    end

    def update
      report = DailyReport.find(params[:id])
      if report.update(report_params)
        redirect_to report, notice: "Report updated."
      else
        redirect_to report, alert: report.errors.full_messages.join(", ")
      end
    end

    def regenerate_summary
      report = DailyReport.find(params[:id])
      GenerateSummaryJob.perform_later(report.id)
      redirect_to report, notice: "Summary regeneration queued."
    end

    def mark_reviewed
      report = DailyReport.find(params[:id])
      report.update!(reviewed_at: Time.current, reviewed_by: current_user_name)
      redirect_to report, notice: "Report marked as reviewed."
    end

    private

    def report_params
      params.require(:daily_report).permit(:human_summary, tags: [])
    end

    def serialize(report)
      {
        id: report.id,
        date: report.date,
        status: report.status,
        summary: report.summary,
        ai_summary: report.ai_summary,
        human_summary: report.human_summary,
        reviewed: report.reviewed?,
        reviewed_by: report.reviewed_by,
        reviewed_at: report.reviewed_at,
        tags: report.tags,
        commit_count: report.commit_entries.count,
        created_at: report.created_at
      }
    end

    def serialize_commit(commit)
      {
        id: commit.id,
        sha: commit.sha,
        message: commit.message,
        author: commit.author,
        category: commit.effective_category,
        is_breaking: commit.is_breaking,
        notes: commit.notes
      }
    end

    def current_user_name
      # Override in host app via authentication
      "unknown"
    end

    def pagination_props(collection)
      # Placeholder — will integrate with kaminari or pagy
      { current_page: 1, total_pages: 1, total_count: collection.count }
    end
  end
end
