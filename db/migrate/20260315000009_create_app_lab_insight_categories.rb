class CreateAppLabInsightCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_insight_categories do |t|
      t.string :name, null: false
      t.string :icon
      t.text :description
      t.timestamps
      t.index :name, unique: true
    end
  end
end
