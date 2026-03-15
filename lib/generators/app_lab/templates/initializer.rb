# Separate database for App Lab (recommended)
#
# 1. Add this to your config/database.yml for each environment:
#
#   production:
#     primary:
#       <<: *default
#       database: your_app_production
#     app_lab:
#       adapter: sqlite3
#       database: storage/production_app_lab.sqlite3
#       migrations_paths: db/app_lab_migrate
#
# 2. Then uncomment the two lines below:

AppLab.configure do |config|
  # General settings
  config.enabled = true
  config.mount_path = "/app_lab"

  # Database (uncomment for separate SQLite database)
  # config.database = :separate
  # config.connects_to = { database: { writing: :app_lab } }

  # Authentication
  # Set to false to disable authentication (not recommended for production)
  config.authentication_enabled = true
  # config.authentication_method = proc {
  #   redirect_to "/login" unless user_signed_in? && current_user.admin?
  # }

  # GitHub integration
  config.github_enabled = true
  config.github_access_token = ENV["GITHUB_TOKEN"]
  config.github_repository = ENV.fetch("GITHUB_REPOSITORY", "owner/repo")
  config.github_branch = "main"

  # AI configuration
  # Supported providers: :anthropic, :kimi
  config.ai_provider = :anthropic
  config.ai_api_key = ENV["ANTHROPIC_API_KEY"]
  config.ai_model = "claude-sonnet-4-5-20250514"
  config.ai_cache_enabled = true
  config.ai_cache_ttl = 24.hours

  # Security scanning
  config.security_enabled = true
  config.security_scheduled_time = "23:00"
  config.security_scanners = [:brakeman, :bundle_audit, :semgrep]
  config.security_critical_notification_channels = [:slack, :email]

  # Best practices
  config.best_practices_enabled = true
  config.best_practices_auto_verify = true
  config.best_practices_check_frequency = :daily

  # Insights
  config.insights_enabled = true
  config.insights_detection_frequency = :daily
  config.insights_rules = :all

  # Notifications
  config.notifications_slack_webhook_url = ENV["SLACK_WEBHOOK_URL"]
  config.notifications_email_recipients = []
  config.notifications_digest_time = "09:00"

  # Data retention
  config.retention_daily_reports = 90.days
  config.retention_security_scans = 365.days
  config.retention_insights = 180.days
  config.retention_max_findings = 10_000
end
