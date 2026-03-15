module AppLab
  class SecurityScanJob < ApplicationJob
    queue_as :app_lab

    def perform(scanners: nil)
      return unless AppLab.configuration.security_enabled

      scanners ||= AppLab.configuration.security_scanners

      scanners.each do |scanner_type|
        scan = SecurityScan.create!(
          scan_type: scanner_type,
          status: :running,
          started_at: Time.current
        )

        begin
          scanner = Services::Security::ScannerFactory.build(scanner_type)
          results = scanner.run

          findings = results[:findings].map do |f|
            scan.security_findings.create!(
              severity: f[:severity],
              category: f[:category],
              file_path: f[:file_path],
              line_number: f[:line_number],
              description: f[:description],
              confidence: f[:confidence],
              cwe_id: f[:cwe_id],
              owasp_category: f[:owasp_category]
            )
          end

          scan.update!(
            status: :completed,
            completed_at: Time.current,
            total_issues: findings.size,
            critical_count: findings.count { |f| f.critical? },
            high_count: findings.count { |f| f.high? },
            medium_count: findings.count { |f| f.medium? },
            low_count: findings.count { |f| f.low? },
            raw_output: results[:raw_output],
            summary: results[:summary]
          )

          # Generate AI remediation for critical/high findings
          findings.select { |f| f.critical? || f.high? }.each do |finding|
            GenerateRemediationJob.perform_later(finding.id)
          end

          # Notify on critical findings
          if scan.has_critical_findings?
            NotifyCriticalFindingsJob.perform_later(scan.id)
          end
        rescue => e
          scan.update!(status: :failed, completed_at: Time.current)
          raise
        end
      end
    end
  end
end
