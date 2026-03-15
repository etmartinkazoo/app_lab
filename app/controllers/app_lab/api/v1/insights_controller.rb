module AppLab
  module Api
    module V1
      class InsightsController < BaseController
        def index
          findings = InsightFinding.actionable.recent.includes(:insight_rule).limit(params[:limit] || 50)
          render json: findings.map { |f|
            {
              id: f.id, title: f.title, severity: f.severity,
              effort: f.effort_estimate, file_path: f.file_path,
              status: f.status, detected_at: f.detected_at
            }
          }
        end

        def scan
          InsightScanJob.perform_later
          render json: { status: "queued" }
        end

        def update
          finding = InsightFinding.find(params[:id])
          finding.update!(params.permit(:status, :notes))
          render json: { status: "updated" }
        end

        def metrics
          render json: InsightMetric.recent.limit(100).map { |m|
            { name: m.metric_name, value: m.metric_value, recorded_at: m.recorded_at }
          }
        end

        def trends
          data = InsightFinding.where("detected_at > ?", 30.days.ago)
                               .group("DATE(detected_at)")
                               .count
          render json: data.map { |date, count| { date: date, count: count } }
        end
      end
    end
  end
end
