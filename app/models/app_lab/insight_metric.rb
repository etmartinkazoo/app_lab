module AppLab
  class InsightMetric < ApplicationRecord
    validates :metric_name, presence: true
    validates :metric_value, presence: true
    validates :recorded_at, presence: true

    scope :recent, -> { order(recorded_at: :desc) }
    scope :for_metric, ->(name) { where(metric_name: name) }
    scope :since, ->(time) { where("recorded_at >= ?", time) }
  end
end
