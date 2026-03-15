module AppLab
  class InsightRule < ApplicationRecord
    belongs_to :category, class_name: "AppLab::InsightCategory"
    has_many :insight_findings, dependent: :destroy

    enum :severity, { low: 0, medium: 1, high: 2, critical: 3 }
    enum :effort_estimate, { quick: 0, medium_effort: 1, large: 2 }, prefix: true

    validates :name, presence: true
    validates :severity, presence: true

    scope :enabled, -> { where(is_enabled: true) }
  end
end
