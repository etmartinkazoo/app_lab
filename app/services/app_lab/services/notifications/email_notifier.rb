module AppLab
  module Services
    module Notifications
      class EmailNotifier
        def send_digest(report)
          recipients = AppLab.configuration.notifications_email_recipients
          return if recipients.empty?

          AppLab.logger.info("Email digest would be sent to: #{recipients.join(', ')}")
          # TODO: Implement via ActionMailer when mailer templates are created
        end

        def send_critical_alert(scan, findings)
          recipients = AppLab.configuration.notifications_email_recipients
          return if recipients.empty?

          AppLab.logger.info("Critical alert email would be sent to: #{recipients.join(', ')}")
          # TODO: Implement via ActionMailer when mailer templates are created
        end
      end
    end
  end
end
