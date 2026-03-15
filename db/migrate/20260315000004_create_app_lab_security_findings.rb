class CreateAppLabSecurityFindings < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_security_findings do |t|
      t.references :security_scan, null: false, foreign_key: { to_table: :app_lab_security_scans }
      t.integer :severity, null: false
      t.string :category
      t.string :file_path
      t.integer :line_number
      t.text :description, null: false
      t.integer :confidence
      t.string :cwe_id
      t.string :owasp_category
      t.text :ai_remediation
      t.text :human_remediation
      t.integer :status, default: 0, null: false
      t.string :assigned_to
      t.datetime :resolved_at
      t.text :resolution_notes
      t.timestamps
      t.index :severity
      t.index :status
      t.index :cwe_id
    end
  end
end
