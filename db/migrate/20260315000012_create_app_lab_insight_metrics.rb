class CreateAppLabInsightMetrics < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_insight_metrics do |t|
      t.string :metric_name, null: false
      t.decimal :metric_value, precision: 15, scale: 4, null: false
      t.datetime :recorded_at, null: false
      t.json :context
      t.timestamps
      t.index [:metric_name, :recorded_at]
      t.index :recorded_at
    end
  end
end
