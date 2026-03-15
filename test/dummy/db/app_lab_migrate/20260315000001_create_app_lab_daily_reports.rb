class CreateAppLabDailyReports < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_daily_reports do |t|
      t.date :date, null: false
      t.integer :status, default: 0, null: false
      t.json :raw_commits
      t.text :ai_summary
      t.text :human_summary
      t.string :reviewed_by
      t.datetime :reviewed_at
      t.json :tags
      t.timestamps
      t.index :date, unique: true
      t.index :status
    end
  end
end
