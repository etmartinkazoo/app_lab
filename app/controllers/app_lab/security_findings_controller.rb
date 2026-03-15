module AppLab
  class SecurityFindingsController < ApplicationController
    def show
      finding = SecurityFinding.find(params[:id])
      render_inertia "Security/FindingDetail", props: {
        finding: serialize(finding)
      }
    end

    def update
      finding = SecurityFinding.find(params[:id])
      if finding.update(finding_params)
        redirect_to finding, notice: "Finding updated."
      else
        redirect_to finding, alert: finding.errors.full_messages.join(", ")
      end
    end

    def assign
      finding = SecurityFinding.find(params[:id])
      finding.update!(assigned_to: params[:assigned_to], status: :in_progress)
      redirect_to finding, notice: "Finding assigned."
    end

    def resolve
      finding = SecurityFinding.find(params[:id])
      finding.update!(status: :fixed, resolved_at: Time.current, resolution_notes: params[:resolution_notes])
      redirect_to finding, notice: "Finding resolved."
    end

    def mark_false_positive
      finding = SecurityFinding.find(params[:id])
      finding.update!(status: :false_positive, resolution_notes: params[:resolution_notes])
      redirect_to finding, notice: "Marked as false positive."
    end

    private

    def finding_params
      params.require(:security_finding).permit(:human_remediation, :status, :resolution_notes)
    end

    def serialize(finding)
      {
        id: finding.id,
        severity: finding.severity,
        category: finding.category,
        file_path: finding.file_path,
        line_number: finding.line_number,
        description: finding.description,
        confidence: finding.confidence,
        cwe_id: finding.cwe_id,
        owasp_category: finding.owasp_category,
        ai_remediation: finding.ai_remediation,
        human_remediation: finding.human_remediation,
        status: finding.status,
        assigned_to: finding.assigned_to,
        resolved_at: finding.resolved_at,
        resolution_notes: finding.resolution_notes,
        scan: {
          id: finding.security_scan.id,
          scan_type: finding.security_scan.scan_type,
          completed_at: finding.security_scan.completed_at
        }
      }
    end
  end
end
