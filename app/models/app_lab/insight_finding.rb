module AppLab
  class InsightFinding < ApplicationRecord
    belongs_to :insight_rule

    enum :status, { open: 0, in_progress: 1, resolved: 2, ignored: 3 }

    validates :title, presence: true
    validates :status, presence: true

    scope :actionable, -> { where(status: [:open, :in_progress]) }
    scope :recent, -> { order(detected_at: :desc) }

    delegate :severity, :effort_estimate, :category, to: :insight_rule
  end
end
