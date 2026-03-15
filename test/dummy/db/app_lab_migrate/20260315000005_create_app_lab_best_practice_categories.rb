class CreateAppLabBestPracticeCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_best_practice_categories do |t|
      t.string :name, null: false
      t.text :description
      t.integer :display_order, default: 0
      t.string :icon
      t.timestamps
      t.index :name, unique: true
      t.index :display_order
    end
  end
end
