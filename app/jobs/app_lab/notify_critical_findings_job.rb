module AppLab
  class NotifyCriticalFindingsJob < ApplicationJob
    queue_as :app_lab_urgent

    def perform(scan_id)
      scan = SecurityScan.find(scan_id)
      critical_findings = scan.security_findings.where(severity: :critical)

      AppLab.configuration.security_critical_notification_channels.each do |channel|
        case channel
        when :slack
          Services::Notifications::SlackNotifier.new.send_critical_alert(scan, critical_findings)
        when :email
          Services::Notifications::EmailNotifier.new.send_critical_alert(scan, critical_findings)
        end
      end
    end
  end
end
