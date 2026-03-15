module AppLab
  class BestPracticeVerificationJob < ApplicationJob
    queue_as :app_lab

    def perform
      return unless AppLab.configuration.best_practices_enabled

      BestPracticeItem.where(verification_type: [:automated, :hybrid]).find_each do |item|
        next unless item.automation_rule.present?

        verifier = Services::Practices::AutoVerifier.new(item)
        result = verifier.verify

        item.best_practice_checks.create!(
          status: result[:passed] ? :passed : :failed,
          checked_at: Time.current,
          auto_verified: true,
          auto_verification_data: result[:data],
          verification_method: result[:method]
        )
      end

      # Capture snapshot
      Services::Practices::SnapshotCapture.new.capture
    end
  end
end
