module AppLab
  class DailyReport < ApplicationRecord
    has_many :commit_entries, dependent: :destroy

    enum :status, { pending: 0, processing: 1, completed: 2, failed: 3 }

    validates :date, presence: true, uniqueness: true
    validates :status, presence: true

    scope :recent, -> { order(date: :desc) }
    scope :reviewed, -> { where.not(reviewed_at: nil) }
    scope :unreviewed, -> { where(reviewed_at: nil) }

    def reviewed?
      reviewed_at.present?
    end

    def summary
      human_summary.presence || ai_summary
    end
  end
end
