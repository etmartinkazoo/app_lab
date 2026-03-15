class CreateAppLabBestPracticeChecks < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_best_practice_checks do |t|
      t.references :item, null: false, foreign_key: { to_table: :app_lab_best_practice_items }
      t.integer :status, default: 0, null: false
      t.datetime :checked_at
      t.string :checked_by
      t.text :notes
      t.boolean :auto_verified, default: false
      t.json :auto_verification_data
      t.string :verification_method
      t.timestamps
      t.index :status
    end
  end
end
