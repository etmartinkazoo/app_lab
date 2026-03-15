module AppLab
  class InsightCategory < ApplicationRecord
    has_many :insight_rules, foreign_key: :category_id, dependent: :destroy

    validates :name, presence: true, uniqueness: true
  end
end
