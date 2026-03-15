module AppLab
  class BestPracticeItem < ApplicationRecord
    belongs_to :category, class_name: "AppLab::BestPracticeCategory"
    has_many :best_practice_checks, foreign_key: :item_id, dependent: :destroy

    enum :verification_type, { automated: 0, manual: 1, hybrid: 2 }

    validates :name, presence: true
    validates :verification_type, presence: true

    scope :critical, -> { where(is_critical: true) }

    def latest_check
      best_practice_checks.order(checked_at: :desc).first
    end

    def current_status
      latest_check&.status || "not_started"
    end
  end
end
