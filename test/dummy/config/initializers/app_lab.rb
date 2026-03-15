AppLab.configure do |config|
  config.enabled = true
  config.authentication_enabled = false
  config.github_enabled = false
  config.security_enabled = false
  config.ai_provider = :anthropic

  # Separate database
  config.database = :separate
  config.connects_to = { database: { writing: :app_lab } }
end
