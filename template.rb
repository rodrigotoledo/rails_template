# frozen_string_literal: true

gem_group :development do
  gem 'annotate'
  gem 'brakeman'
  gem 'bullet'
end

gem_group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'rspec-rails', '~> 6.1.0'
  gem 'faker'
  gem 'guard-rspec', require: false
  gem 'shoulda-matchers', require: false
  gem 'rails-controller-testing'
  gem 'factory_bot_rails'
  gem 'simplecov', require: false
  gem 'rufo'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  gem 'rubocop-rails'
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'solargraph'
end

gem_group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'rack-cors', '~> 2.0'
gem 'redis'
gem 'pg'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'image_processing', '~> 1.2'
gem 'bcrypt', '~> 3.1.7'
gem 'tailwindcss-rails'
gem 'stimulus_reflex', '3.5.0'
gem 'redis-session-store'

# DO THIS AFTER ALL GEMS ARE SET
# Replace 'string' with "string" in the Gemfile so RuboCop is happy
gsub_file 'Gemfile', /'([^']*)'/, '"\1"'

# Install gems
run 'bundle install'

inject_into_file 'config/environments/development.rb', before: "end\n" do
  <<-'RUBY'
  config.action_controller.raise_on_missing_callback_actions = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.hosts.clear
  config.hosts << /[a-z0-9-.]+\.ngrok\.io/
  config.hosts << /.*\.tunnelmole\.net/
  config.hosts << 'localhost'
  config.action_controller.allow_forgery_protection = false
  RUBY
end

rails_command('rails tailwindcss:install')
rails_command('db:migrate')
rails_command('active_storage:install')
rails_command('importmap:install')
rails_command('turbo:install')
rails_command('action_text:install')
rails_command('stimulus:install')
rails_command('db:migrate')
rails_command('stimulus_reflex:install')
rails_command('rspec:install')

# Setup RSpec and test related config
run 'mkdir spec/support'

inject_into_file 'spec/spec_helper.rb', before: "RSpec.configure do |config|\n" do
  <<~RUBY
    require "simplecov"
    SimpleCov.start
  RUBY
end

inject_into_file 'spec/rails_helper.rb', before: "require 'rspec/rails'\n" do
  <<~RUBY
    require "faker"
    Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
  RUBY
end

system('bundle exec guard init rspec')

file 'spec/support/factory_bot.rb', <<~CODE
  RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
  end
CODE

file 'spec/support/shoulda.rb', <<~CODE
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
CODE

directory 'rails_app/app', 'app'
directory 'rails_app/bin', 'bin'
directory 'rails_app/config', 'config'

copy_file 'rails_app/.dockerconfig', '.dockerconfig'
copy_file 'rails_app/.editorconfig', '.editorconfig'
copy_file 'rails_app/.env', '.env'
copy_file 'rails_app/.env', '.env.local'
copy_file 'rails_app/.env', '.env.test'
copy_file 'rails_app/.gitignore', '.gitignore'
copy_file 'rails_app/.rubocop.yml', '.rubocop.yml'
copy_file 'rails_app/.ruby-version', '.ruby-version'
copy_file 'rails_app/docker-compose.development.yml', 'docker-compose.development.yml'
copy_file 'rails_app/Dockerfile.development', 'Dockerfile.development'
copy_file 'rails_app/Procfile.dev', 'Procfile.dev'

def replace_application_name
  file_patterns = [
    'app/**/*.rb',
    'app/**/*.erb',
    'config/**/*.rb',
    'config/**/*.yml',
    'config/**/*.rb'
  ]

  file_patterns.each do |pattern|
    Dir.glob(pattern).each do |file|
      if file.end_with?('.erb')
        gsub_file file, 'MY_APPLICATION', '<%= ENV["APPLICATION_NAME"] %>'
      else
        gsub_file file, 'MY_APPLICATION', 'ENV["APPLICATION_NAME"]'
      end
    end
  end
end

replace_application_name

# adds x86_64-linux platform in the Gemfile.lock
run 'bundle lock --add-platform x86_64-linux'
# clear logs
rails_command 'log:clear'

# Fix Rubocop Offences
run 'rm -rf spec/views'
run 'rubocop -A'
