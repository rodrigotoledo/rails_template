# frozen_string_literal: true

source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "pg", "~> 1.1"
gem "rails", "~> 7.2.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"
# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "pry"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "annotate"
  gem "bullet"
  gem "bundler-audit"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "foreman"
  gem "guard-rspec", require: false
  gem "letter_opener"
  gem "letter_opener_web"
  gem "rspec-rails"
  gem "rubocop-factory_bot"
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-rspec"
end

gem "database_cleaner-active_record", group: :test
gem "faker"
gem "rspec-json_expectations", group: :test
gem "shoulda-matchers", group: :test

gem "simplecov", require: false, group: :test

gem "csv"
gem "dotenv", groups: %i[development test]
gem "email_validator"
gem "jwt", "~> 2.5"
gem "pagy", "~> 9.0"
gem "sidekiq"
