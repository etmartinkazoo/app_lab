class CreateAppLabNotificationLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :app_lab_notification_logs do |t|
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
end
