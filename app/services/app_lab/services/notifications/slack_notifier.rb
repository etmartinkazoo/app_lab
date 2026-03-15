require "net/http"
require "json"

module AppLab
  module Services
    module Notifications
      class SlackNotifier
        def initialize(webhook_url: nil)
          @webhook_url = webhook_url || AppLab.configuration.notifications_slack_webhook_url
        end

        def send_digest(report)
          post_message(
            text: "Daily Commit Report - #{report.date}",
            blocks: [
              section("*Daily Commit Report - #{report.date}*"),
              section(report.summary || "No summary available."),
              section("_#{report.commit_entries.count} commits | #{report.commit_entries.breaking.count} breaking changes_")
            ]
          )
        end

        def send_critical_alert(scan, findings)
          post_message(
            text: "CRITICAL Security Alert",
            blocks: [
              section(":rotating_light: *CRITICAL Security Findings*"),
              section("Scan: #{scan.scan_type} | #{findings.count} critical finding(s)"),
              *findings.map { |f| section("- #{f.description} (`#{f.file_path}:#{f.line_number}`)") }
            ]
          )
        end

        private

        def post_message(payload)
          return unless @webhook_url

          uri = URI(@webhook_url)
          request = Net::HTTP::Post.new(uri)
          request["Content-Type"] = "application/json"
          request.body = payload.to_json

          Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            response = http.request(request)
            unless response.code.to_i == 200
              AppLab.logger.error("Slack notification failed: #{response.code}")
            end
          end
        rescue => e
          AppLab.logger.error("Slack notification error: #{e.message}")
        end

        def section(text)
          { type: "section", text: { type: "mrkdwn", text: text } }
        end
      end
    end
  end
end
