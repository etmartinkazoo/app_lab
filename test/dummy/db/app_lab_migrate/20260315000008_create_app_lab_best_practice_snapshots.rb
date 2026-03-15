class CreateAppLabBestPracticeSnapshots < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_best_practice_snapshots do |t|
      t.datetime :captured_at, null: false
      t.integer :total_items, default: 0
      t.integer :passed_count, default: 0
      t.integer :failed_count, default: 0
      t.integer :na_count, default: 0
      t.decimal :overall_score, precision: 5, scale: 2
      t.json :category_scores
      t.timestamps
      t.index :captured_at
    end
  end
end
