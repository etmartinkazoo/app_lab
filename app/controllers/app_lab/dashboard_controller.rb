module AppLab
  class DashboardController < ApplicationController
    def index
      render_inertia "Dashboard", props: {
        latest_report: serialize_report(DailyReport.recent.first),
        security_summary: security_summary,
        practice_score: practice_score,
        recent_insights: recent_insights
      }
    end

    private

    def serialize_report(report)
      return nil unless report

      {
        id: report.id,
        date: report.date,
        status: report.status,
        summary: report.summary,
        reviewed: report.reviewed?,
        commit_count: report.commit_entries.count
      }
    end

    def security_summary
      scan = SecurityScan.completed.recent.first
      return nil unless scan

      {
        last_scan_at: scan.completed_at,
        scan_type: scan.scan_type,
        total_issues: scan.total_issues,
        critical_count: scan.critical_count,
        high_count: scan.high_count,
        open_findings: SecurityFinding.actionable.count
      }
    end

    def practice_score
      snapshot = BestPracticeSnapshot.recent.first
      return nil unless snapshot

      {
        overall_score: snapshot.overall_score,
        grade: snapshot.health_grade,
        total_items: snapshot.total_items,
        passed_count: snapshot.passed_count,
        captured_at: snapshot.captured_at
      }
    end

    def recent_insights
      InsightFinding.actionable.recent.limit(5).map do |finding|
        {
          id: finding.id,
          title: finding.title,
          severity: finding.severity,
          effort: finding.effort_estimate,
          file_path: finding.file_path,
          detected_at: finding.detected_at
        }
      end
    end
  end
end
