module AppLab
  class SecurityFinding < ApplicationRecord
    belongs_to :security_scan

    enum :severity, { info: 0, low: 1, medium: 2, high: 3, critical: 4 }
    enum :confidence, { low_confidence: 0, medium_confidence: 1, high_confidence: 2 }, prefix: true
    enum :status, { open: 0, in_progress: 1, fixed: 2, false_positive: 3, accepted_risk: 4 }

    validates :severity, presence: true
    validates :description, presence: true
    validates :status, presence: true

    scope :actionable, -> { where(status: [:open, :in_progress]) }
    scope :by_severity, ->(sev) { where(severity: sev) }
    scope :unresolved, -> { where.not(status: [:fixed, :false_positive, :accepted_risk]) }

    def resolved?
      fixed? || false_positive? || accepted_risk?
    end

    def remediation
      human_remediation.presence || ai_remediation
    end
  end
end
