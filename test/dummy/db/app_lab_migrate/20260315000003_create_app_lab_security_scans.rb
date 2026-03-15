class CreateAppLabSecurityScans < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_security_scans do |t|
      t.integer :scan_type, null: false
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :status, default: 0, null: false
      t.integer :total_issues, default: 0
      t.integer :critical_count, default: 0
      t.integer :high_count, default: 0
      t.integer :medium_count, default: 0
      t.integer :low_count, default: 0
      t.json :raw_output
      t.text :summary
      t.timestamps
      t.index :scan_type
      t.index :status
      t.index :started_at
    end
  end
end
