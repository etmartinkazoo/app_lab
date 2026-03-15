module AppLab
  class Configuration
    # General
    attr_accessor :enabled, :mount_path

    # Authentication
    attr_accessor :authentication_enabled, :authentication_method

    # GitHub integration
    attr_accessor :github_enabled, :github_access_token, :github_repository, :github_branch

    # AI configuration
    attr_accessor :ai_provider, :ai_api_key, :ai_model, :ai_cache_enabled, :ai_cache_ttl

    # Security scanning
    attr_accessor :security_enabled, :security_scheduled_time, :security_scanners,
                  :security_critical_notification_channels

    # Best practices
    attr_accessor :best_practices_enabled, :best_practices_auto_verify, :best_practices_check_frequency

    # Insights
    attr_accessor :insights_enabled, :insights_detection_frequency, :insights_rules

    # Notifications
    attr_accessor :notifications_slack_webhook_url, :notifications_email_recipients,
                  :notifications_digest_time

    # Data retention
    attr_accessor :retention_daily_reports, :retention_security_scans, :retention_insights,
                  :retention_max_findings

    # Database
    attr_accessor :database, :connects_to

    def initialize
      # General
      @enabled = true
      @mount_path = "/app_lab"

      # Authentication
      @authentication_enabled = true
      @authentication_method = nil

      # GitHub
      @github_enabled = true
      @github_access_token = nil
      @github_repository = nil
      @github_branch = "main"

      # AI - default to Anthropic (Claude)
      @ai_provider = :anthropic
      @ai_api_key = nil
      @ai_model = "claude-sonnet-4-5-20250514"
      @ai_cache_enabled = true
      @ai_cache_ttl = 24.hours

      # Security
      @security_enabled = true
      @security_scheduled_time = "23:00"
      @security_scanners = [:brakeman, :bundle_audit, :semgrep]
      @security_critical_notification_channels = [:slack, :email]

      # Best practices
      @best_practices_enabled = true
      @best_practices_auto_verify = true
      @best_practices_check_frequency = :daily

      # Insights
      @insights_enabled = true
      @insights_detection_frequency = :daily
      @insights_rules = :all

      # Notifications
      @notifications_slack_webhook_url = nil
      @notifications_email_recipients = []
      @notifications_digest_time = "09:00"

      # Data retention
      @retention_daily_reports = 90.days
      @retention_security_scans = 365.days
      @retention_insights = 180.days
      @retention_max_findings = 10_000

      # Database
      @database = :primary
      @connects_to = nil
    end

    def separate_database?
      @database == :separate
    end

    def validate!
      validate_ai_config!
      validate_github_config!
      validate_security_config!
    end

    private

    def validate_ai_config!
      return unless @ai_provider

      unless [:anthropic, :kimi].include?(@ai_provider)
        raise ArgumentError, "AI provider must be :anthropic or :kimi, got :#{@ai_provider}"
      end
    end

    def validate_github_config!
      return unless @github_enabled

      if @github_access_token.nil?
        Rails.logger.warn("[AppLab] GitHub integration enabled but no access token configured")
      end
    end

    def validate_security_config!
      return unless @security_enabled

      valid_scanners = [:brakeman, :bundle_audit, :semgrep, :zap]
      invalid = @security_scanners - valid_scanners
      if invalid.any?
        raise ArgumentError, "Invalid security scanners: #{invalid.join(', ')}"
      end
    end
  end
end
