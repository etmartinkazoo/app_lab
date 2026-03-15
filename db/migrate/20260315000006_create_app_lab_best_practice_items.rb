class CreateAppLabBestPracticeItems < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_best_practice_items do |t|
      t.references :category, null: false, foreign_key: { to_table: :app_lab_best_practice_categories }
      t.string :name, null: false
      t.text :description
      t.integer :verification_type, default: 0, null: false
      t.json :automation_rule
      t.integer :weight, default: 1
      t.string :documentation_url
      t.boolean :is_critical, default: false
      t.timestamps
    end
  end
end
