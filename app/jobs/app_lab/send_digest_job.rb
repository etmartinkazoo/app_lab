module AppLab
  class SendDigestJob < ApplicationJob
    queue_as :app_lab

    def perform(report_id)
      report = DailyReport.find(report_id)

      if AppLab.configuration.notifications_slack_webhook_url.present?
        Services::Notifications::SlackNotifier.new.send_digest(report)
      end

      if AppLab.configuration.notifications_email_recipients.any?
        Services::Notifications::EmailNotifier.new.send_digest(report)
      end
    end
  end
end
