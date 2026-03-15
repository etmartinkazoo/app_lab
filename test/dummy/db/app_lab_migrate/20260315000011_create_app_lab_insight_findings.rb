class CreateAppLabInsightFindings < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_insight_findings do |t|
      t.references :insight_rule, null: false, foreign_key: { to_table: :app_lab_insight_rules }
      t.string :title, null: false
      t.text :description
      t.string :file_path
      t.integer :line_number
      t.text :code_snippet
      t.text :suggested_fix
      t.integer :status, default: 0, null: false
      t.datetime :detected_at
      t.datetime :resolved_at
      t.string :assigned_to
      t.text :notes
      t.timestamps
      t.index :status
      t.index :detected_at
    end
  end
end
