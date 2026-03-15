module AppLab
  class BestPracticeSnapshot < ApplicationRecord
    validates :captured_at, presence: true

    scope :recent, -> { order(captured_at: :desc) }

    def health_grade
      case overall_score
      when 90..100 then "A"
      when 80..89 then "B"
      when 70..79 then "C"
      when 60..69 then "D"
      else "F"
      end
    end
  end
end
