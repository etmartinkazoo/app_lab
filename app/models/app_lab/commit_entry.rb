module AppLab
  class CommitEntry < ApplicationRecord
    belongs_to :daily_report

    enum :category, { feature: 0, fix: 1, refactor: 2, chore: 3, dependency: 4, security: 5 }
    enum :ai_category, { ai_feature: 0, ai_fix: 1, ai_refactor: 2, ai_chore: 3, ai_dependency: 4, ai_security: 5 }, prefix: true
    enum :human_category, { human_feature: 0, human_fix: 1, human_refactor: 2, human_chore: 3, human_dependency: 4, human_security: 5 }, prefix: true

    validates :sha, presence: true, uniqueness: true
    validates :message, presence: true
    validates :author, presence: true

    scope :breaking, -> { where(is_breaking: true) }
    scope :by_category, ->(cat) { where(category: cat) }

    def effective_category
      human_category || ai_category || category
    end
  end
end
