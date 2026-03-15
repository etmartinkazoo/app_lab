module AppLab
  module Api
    module V1
      class SecurityController < BaseController
        def scans
          scans = SecurityScan.recent.limit(params[:limit] || 20)
          render json: scans.map { |s|
            {
              id: s.id, scan_type: s.scan_type, status: s.status,
              total_issues: s.total_issues, critical_count: s.critical_count,
              completed_at: s.completed_at
            }
          }
        end

        def trigger
          SecurityScanJob.perform_later
          render json: { status: "queued" }
        end

        def findings
          scope = SecurityFinding.all
          scope = scope.where(severity: params[:severity]) if params[:severity]
          scope = scope.where(status: params[:status]) if params[:status]
          render json: scope.limit(params[:limit] || 50).map { |f|
            {
              id: f.id, severity: f.severity, category: f.category,
              description: f.description, file_path: f.file_path,
              status: f.status
            }
          }
        end

        def update_finding
          finding = SecurityFinding.find(params[:id])
          finding.update!(finding_params)
          render json: { status: "updated" }
        end

        def trends
          data = SecurityScan.completed
                             .where("completed_at > ?", 30.days.ago)
                             .order(:completed_at)
                             .map { |s| { date: s.completed_at.to_date, issues: s.total_issues } }
          render json: data
        end

        private

        def finding_params
          params.permit(:status, :human_remediation, :resolution_notes)
        end
      end
    end
  end
end
