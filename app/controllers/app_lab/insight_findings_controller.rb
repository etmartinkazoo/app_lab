module AppLab
  class InsightFindingsController < ApplicationController
    def index
      findings = InsightFinding.actionable.recent.includes(:insight_rule)
      render_inertia "Insights/Index", props: {
        findings: findings.map { |f| serialize(f) },
        summary: insights_summary
      }
    end

    def show
      finding = InsightFinding.find(params[:id])
      render_inertia "Insights/Show", props: {
        finding: serialize_detail(finding)
      }
    end

    def update
      finding = InsightFinding.find(params[:id])
      if finding.update(finding_params)
        redirect_to finding, notice: "Insight updated."
      else
        redirect_to finding, alert: finding.errors.full_messages.join(", ")
      end
    end

    def assign
      finding = InsightFinding.find(params[:id])
      finding.update!(assigned_to: params[:assigned_to], status: :in_progress)
      redirect_to finding, notice: "Insight assigned."
    end

    def resolve
      finding = InsightFinding.find(params[:id])
      finding.update!(status: :resolved, resolved_at: Time.current, notes: params[:notes])
      redirect_to finding, notice: "Insight resolved."
    end

    def ignore
      finding = InsightFinding.find(params[:id])
      finding.update!(status: :ignored, notes: params[:notes])
      redirect_to finding, notice: "Insight ignored."
    end

    def scan
      InsightScanJob.perform_later
      redirect_to insight_findings_path, notice: "Insight scan queued."
    end

    def metrics
      render json: InsightMetric.recent.limit(100).map { |m|
        { name: m.metric_name, value: m.metric_value, recorded_at: m.recorded_at, context: m.context }
      }
    end

    def trends
      render json: InsightFinding.group_by_day(:detected_at, range: 30.days.ago..Time.current).count
    end

    private

    def finding_params
      params.require(:insight_finding).permit(:notes, :status)
    end

    def serialize(finding)
      {
        id: finding.id,
        title: finding.title,
        severity: finding.severity,
        effort: finding.effort_estimate,
        status: finding.status,
        file_path: finding.file_path,
        detected_at: finding.detected_at,
        rule_name: finding.insight_rule.name,
        category: finding.category.name
      }
    end

    def serialize_detail(finding)
      serialize(finding).merge(
        description: finding.description,
        line_number: finding.line_number,
        code_snippet: finding.code_snippet,
        suggested_fix: finding.suggested_fix,
        assigned_to: finding.assigned_to,
        resolved_at: finding.resolved_at,
        notes: finding.notes,
        rule: {
          name: finding.insight_rule.name,
          description: finding.insight_rule.description,
          documentation_url: finding.insight_rule.documentation_url
        }
      )
    end

    def insights_summary
      {
        total_open: InsightFinding.where(status: :open).count,
        total_in_progress: InsightFinding.where(status: :in_progress).count,
        critical: InsightFinding.actionable.joins(:insight_rule).where(app_lab_insight_rules: { severity: :critical }).count,
        resolved_this_week: InsightFinding.where(status: :resolved).where("resolved_at > ?", 1.week.ago).count
      }
    end
  end
end
