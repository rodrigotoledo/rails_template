# add other gems
gem_group :development do
  gem "guard-rspec", require: false
end

# spec and linter related
gem_group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "rspec-rails"
  gem "rails-controller-testing"
end

gem_group :development, :test do
  gem "factory_bot_rails"
  gem "simplecov", require: false
  gem "rubocop-rspec" # rspec rules for rubocop
  gem "rubocop-rails" # rails rules for rubocop
end

# environment
gem "dotenv-rails"
gem "bootstrap", "~> 5.0"
gem "bootstrap_form", "~> 5.0"


# DO THIS AFTER ALL GEMS ARE SET
# Replace 'string' with "string" in the Gemfile so RuboCop is happy
gsub_file "Gemfile", /'([^']*)'/, '"\1"'

# Install gems
run "bundle install"

# Setup RSpec and test related config
generate "rspec:install"

run "mkdir spec/factories"
run "mkdir spec/support"

inject_into_file "spec/spec_helper.rb", before: "RSpec.configure do |config|\n" do <<-'RUBY'
  require "simplecov"
  SimpleCov.start
RUBY
end

inject_into_file "spec/rails_helper.rb", before: "require 'rspec/rails'\n" do <<-'RUBY'
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

# add RuboCop config
# create_file ".rubocop.yml"

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

generate(:controller, "welcome index")
# rails_command "generate controller welcome index"
route "root to: 'welcome#index'"

# Fix Rubocop Offences
run "rubocop -A"