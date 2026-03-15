module AppLab
  class SecurityScansController < ApplicationController
    def index
      scans = SecurityScan.recent
      render_inertia "Security/Index", props: {
        scans: scans.map { |s| serialize_scan(s) },
        trends: security_trends
      }
    end

    def show
      scan = SecurityScan.find(params[:id])
      render_inertia "Security/Show", props: {
        scan: serialize_scan(scan),
        findings: scan.security_findings.map { |f| serialize_finding(f) }
      }
    end

    def trigger
      SecurityScanJob.perform_later
      redirect_to security_scans_path, notice: "Security scan queued."
    end

    private

    def serialize_scan(scan)
      {
        id: scan.id,
        scan_type: scan.scan_type,
        status: scan.status,
        started_at: scan.started_at,
        completed_at: scan.completed_at,
        duration: scan.duration,
        total_issues: scan.total_issues,
        critical_count: scan.critical_count,
        high_count: scan.high_count,
        medium_count: scan.medium_count,
        low_count: scan.low_count,
        summary: scan.summary
      }
    end

    def serialize_finding(finding)
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
        remediation: finding.remediation,
        status: finding.status,
        assigned_to: finding.assigned_to
      }
    end

    def security_trends
      SecurityScan.completed
                  .where("completed_at > ?", 30.days.ago)
                  .order(:completed_at)
                  .map { |s| { date: s.completed_at.to_date, issues: s.total_issues, critical: s.critical_count } }
    end
  end
end
