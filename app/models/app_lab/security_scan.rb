module AppLab
  class SecurityScan < ApplicationRecord
    has_many :security_findings, dependent: :destroy

    enum :scan_type, { brakeman: 0, bundle_audit: 1, semgrep: 2, zap: 3 }
    enum :status, { pending: 0, running: 1, completed: 2, failed: 3 }

    validates :scan_type, presence: true
    validates :status, presence: true

    scope :recent, -> { order(started_at: :desc) }
    scope :completed, -> { where(status: :completed) }

    def duration
      return nil unless started_at && completed_at
      completed_at - started_at
    end

    def has_critical_findings?
      critical_count.to_i > 0
    end
  end
end
