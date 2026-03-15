module AppLab
  class BestPracticeCategory < ApplicationRecord
    has_many :best_practice_items, foreign_key: :category_id, dependent: :destroy

    validates :name, presence: true, uniqueness: true

    scope :ordered, -> { order(:display_order) }

    def completion_percentage
      return 0 if best_practice_items.empty?
      passed = best_practice_items.joins(:best_practice_checks).where(app_lab_best_practice_checks: { status: :passed }).distinct.count
      (passed.to_f / best_practice_items.count * 100).round(1)
    end
  end
end
