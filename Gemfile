source "https://rubygems.org"

gemspec

gem "sqlite3", "~> 2.0"
gem "puma", "~> 6.0"

group :development do
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "brakeman", require: false
end

group :test do
  gem "minitest", "~> 5.0"
  gem "factory_bot_rails", "~> 6.0"
  gem "capybara", "~> 3.0"
  gem "selenium-webdriver"
end
