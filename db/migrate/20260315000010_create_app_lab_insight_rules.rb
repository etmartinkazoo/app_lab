class CreateAppLabInsightRules < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_insight_rules do |t|
      t.references :category, null: false, foreign_key: { to_table: :app_lab_insight_categories }
      t.string :name, null: false
      t.text :description
      t.text :detection_logic
      t.integer :severity, default: 0, null: false
      t.integer :effort_estimate, default: 0
      t.string :documentation_url
      t.boolean :is_enabled, default: true
      t.timestamps
    end
  end
end
