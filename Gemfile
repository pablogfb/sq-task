source "https://rubygems.org"

gem "rails", "~> 7.2.1", ">= 7.2.1.1"
gem "sprockets-rails"
gem "pg", "~> 1.5"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"


gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "bootsnap", require: false

# Cron jobs
gem "whenever", require: false

# Background jobs
gem "sidekiq", require: false


group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails", "~> 7.0.0"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
  gem "console_table"
end

group :test do
  gem "shoulda-matchers", require: false
end
