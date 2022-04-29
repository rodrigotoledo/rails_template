# add other gems
gem_group :development do
  gem "guard-rspec", require: false
end

gem_group :test do
  gem 'shoulda-matchers', '~> 5.0'
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "rails-controller-testing"
end

gem_group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "simplecov", require: false
  gem "faker"
  gem "rubocop-rspec" # rspec rules for rubocop
  gem "rubocop-rails" # rails rules for rubocop
end

# environment
gem "image_processing", "~> 1.2"
gem "dotenv-rails"
gem "bootstrap", "~> 5.0"
gem "bootstrap_form", "~> 5.0"
gem "devise"


# DO THIS AFTER ALL GEMS ARE SET
# Replace 'string' with "string" in the Gemfile so RuboCop is happy
gsub_file "Gemfile", /'([^']*)'/, '"\1"'

# rvm gemset
file '.ruby-gemset', "#{@app_name}"
run "rvm use 3.0.3@#{@app_name} --create"

# Install gems
run "bundle install"

generate "devise:install"
generate "devise User"
generate "devise:views"

inject_into_file "app/controllers/application_controller.rb", before: "end\n" do <<-'RUBY'
  before_action :authenticate_user!
RUBY
end

inject_into_file "config/environments/development.rb", before: "end\n" do <<-'RUBY'
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
RUBY
end

rails_command("db:migrate")

# Setup RSpec and test related config
generate "rspec:install"
run "mkdir spec/support"

inject_into_file "spec/spec_helper.rb", before: "RSpec.configure do |config|\n" do <<-'RUBY'
  require "simplecov"
  SimpleCov.start
RUBY
end

inject_into_file "spec/rails_helper.rb", before: "require 'rspec/rails'\n" do <<-'RUBY'
  require "faker"
  require "capybara/rails"
  Capybara.server = :puma, { Silent: true }
  Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
RUBY
end

# init guard with rspec config
system("bundle exec guard init rspec")

create_file ".env"

# create_file "app/assets/stylesheets/application_bootstrap.scss"
file 'app/assets/stylesheets/application_bootstrap.scss', <<-CODE
  @import "bootstrap";
  @import "rails_bootstrap_forms";
CODE

# adds x86_64-linux platform in the Gemfile.lock
run "bundle lock --add-platform x86_64-linux"

file '.rubocop.yml', <<-CODE
  require:
    - rubocop-rails
    - rubocop-rspec

  AllCops:
    NewCops: enable

  Rails:
    Enabled: true
  RSpec:
    Enabled: true
  RSpec/MultipleExpectations:
    Enabled: false
CODE

file 'spec/support/factory_bot.rb', <<-CODE
  RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
  end
CODE

file 'spec/support/shoulda.rb', <<-CODE
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
CODE

append_file ".gitignore" do <<-'GIT'
/tmp
/coverage
GIT
end

generate(:controller, "welcome index")
# rails_command "generate controller welcome index"
route "root to: 'welcome#index'"

# Fix Rubocop Offences
run "rubocop -A"