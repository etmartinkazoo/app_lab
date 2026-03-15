module AppLab
  class BestPracticeCheck < ApplicationRecord
    belongs_to :item, class_name: "AppLab::BestPracticeItem"

    enum :status, { not_started: 0, in_progress: 1, passed: 2, failed: 3, na: 4 }

    validates :status, presence: true

    scope :recent, -> { order(checked_at: :desc) }
  end
end
