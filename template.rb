# frozen_string_literal: true

# DO THIS AFTER ALL GEMS ARE SET
# Replace 'string' with "string" in the Gemfile so RuboCop is happy
gsub_file "Gemfile", /'([^']*)'/, '"\1"'

# Install gems
run "bundle install"

inject_into_file "config/environments/development.rb", before: "end\n" do
  <<-'RUBY'
  config.action_controller.raise_on_missing_callback_actions = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.hosts.clear
  config.hosts << %r{.+\.ngrok-free.app$}
  config.hosts << /.*\.tunnelmole\.net/
  config.hosts << 'localhost'
  config.action_controller.allow_forgery_protection = false
  RUBY
end

rails_command("dev:cache")
rails_command("db:migrate")
rails_command("active_storage:install")
rails_command("importmap:install")
rails_command("turbo:install")
rails_command("action_text:install")
rails_command("stimulus:install")
rails_command("db:migrate")
rails_command("rspec:install")
rails_command("tailwindcss:install")
rails_command("stimulus_reflex:install")

# Setup RSpec and test related config
run "mkdir spec/support"

inject_into_file "spec/spec_helper.rb", before: "RSpec.configure do |config|\n" do
  <<~RUBY
    require "simplecov"
    SimpleCov.start
  RUBY
end

inject_into_file "spec/rails_helper.rb", before: "require 'rspec/rails'\n" do
  <<~RUBY
    require "faker"
    Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
  RUBY
end

system("bundle exec guard init rspec")

file "spec/support/factory_bot.rb", <<~CODE
  RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
  end
CODE

file "spec/support/shoulda.rb", <<~CODE
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
CODE

def source_paths
  Array(super) +
    [__dir__]
end

directory "rails_app/app", "app"
directory "rails_app/bin", "bin"
directory "rails_app/config", "config"

copy_file "rails_app/.dockerignore", ".dockerignore"
copy_file "rails_app/.editorconfig", ".editorconfig"
copy_file "rails_app/.env.example", ".env"
copy_file "rails_app/.env.example", ".env.development"
copy_file "rails_app/.env.example", ".env.test"
copy_file "rails_app/.gitignore", ".gitignore"
copy_file "rails_app/.rubocop.yml", ".rubocop.yml"
copy_file "rails_app/.tool-versions", ".tool-versions"
copy_file "rails_app/docker-compose.development.yml", "docker-compose.development.yml"
copy_file "rails_app/Dockerfile.development", "Dockerfile.development"
copy_file "rails_app/Procfile.dev", "Procfile.dev"
copy_file "rails_app/README.md", "README.md"

def replace_application_name
  file_patterns = [
    "app/**/*.rb",
    "app/**/*.erb",
    "config/**/*.rb",
    "config/**/*.yml",
    "config/**/*.rb"
  ]

  file_patterns.each do |pattern|
    Dir.glob(pattern).each do |file|
      if file.end_with?(".erb")
        gsub_file file, "MY_APPLICATION", '<%= ENV["APPLICATION_NAME"] %>'
      else
        gsub_file file, "MY_APPLICATION", 'ENV["APPLICATION_NAME"]'
      end
    end
  end
end

replace_application_name

# adds x86_64-linux platform in the Gemfile.lock
run "bundle lock --add-platform x86_64-linux"
run "rm -rf spec/views"
