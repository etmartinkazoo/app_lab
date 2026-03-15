class CreateAppLabCommitEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_commit_entries do |t|
      t.references :daily_report, null: false, foreign_key: { to_table: :app_lab_daily_reports }
      t.string :sha, null: false
      t.text :message, null: false
      t.string :author, null: false
      t.integer :category
      t.integer :ai_category
      t.integer :human_category
      t.text :notes
      t.boolean :is_breaking, default: false
      t.timestamps
      t.index :sha, unique: true
      t.index :author
      t.index :category
    end
  end
end
