ActiveRecord::Schema.define do
  # ============================================
  # GitHub Commit Intelligence
  # ============================================

  create_table :app_lab_daily_reports, force: :cascade do |t|
    t.date :date, null: false
    t.integer :status, default: 0, null: false
    t.json :raw_commits
    t.text :ai_summary
    t.text :human_summary
    t.string :reviewed_by
    t.datetime :reviewed_at
    t.json :tags
    t.timestamps
    t.index :date, unique: true
    t.index :status
  end

  create_table :app_lab_commit_entries, force: :cascade do |t|
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

  # ============================================
  # Security Scanning
  # ============================================

  create_table :app_lab_security_scans, force: :cascade do |t|
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

  create_table :app_lab_security_findings, force: :cascade do |t|
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

  # ============================================
  # Best Practices Checklist
  # ============================================

  create_table :app_lab_best_practice_categories, force: :cascade do |t|
    t.string :name, null: false
    t.text :description
    t.integer :display_order, default: 0
    t.string :icon
    t.timestamps
    t.index :name, unique: true
    t.index :display_order
  end

  create_table :app_lab_best_practice_items, force: :cascade do |t|
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

  create_table :app_lab_best_practice_checks, force: :cascade do |t|
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

  create_table :app_lab_best_practice_snapshots, force: :cascade do |t|
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

  # ============================================
  # Performance & Architecture Insights
  # ============================================

  create_table :app_lab_insight_categories, force: :cascade do |t|
    t.string :name, null: false
    t.string :icon
    t.text :description
    t.timestamps
    t.index :name, unique: true
  end

  create_table :app_lab_insight_rules, force: :cascade do |t|
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

  create_table :app_lab_insight_findings, force: :cascade do |t|
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

  create_table :app_lab_insight_metrics, force: :cascade do |t|
    t.string :metric_name, null: false
    t.decimal :metric_value, precision: 15, scale: 4, null: false
    t.datetime :recorded_at, null: false
    t.json :context
    t.timestamps
    t.index [:metric_name, :recorded_at]
    t.index :recorded_at
  end

  # ============================================
  # Notifications
  # ============================================

  create_table :app_lab_notification_logs, force: :cascade do |t|
    t.string :channel, null: false
    t.string :notification_type, null: false
    t.string :recipient
    t.string :subject
    t.text :body
    t.integer :status, default: 0, null: false
    t.datetime :sent_at
    t.text :error_message
    t.timestamps
    t.index :channel
    t.index :notification_type
    t.index :sent_at
  end
end
