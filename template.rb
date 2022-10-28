# add other gems
gem_group :development do
  gem 'guard-rspec', require: false
end

gem_group :test do
  gem 'shoulda-matchers', '~> 5.0'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'rails-controller-testing'
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'simplecov', require: false
  gem 'rufo'
  gem 'rubocop-rspec' # rspec rules for rubocop
  gem 'rubocop-rails' # rails rules for rubocop
  gem 'byebug'
end

# environment
gem 'faker'
gem 'dotenv-rails'
gem 'devise'
gem 'rails_heroicon'
gem 'redis'
gem 'pg'

# DO THIS AFTER ALL GEMS ARE SET
# Replace 'string' with "string" in the Gemfile so RuboCop is happy
gsub_file 'Gemfile', /'([^']*)'/, '"\1"'

# Install gems
run 'bundle install'

generate 'devise:install'
generate 'devise User'
generate 'devise:views'

inject_into_file 'app/controllers/application_controller.rb', before: "end\n" do
  <<-'RUBY'
  before_action :authenticate_user!
  RUBY
end

inject_into_file 'config/environments/development.rb', before: "end\n" do
  <<-'RUBY'
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.hosts << /[a-z0-9-.]+\.ngrok\.io/
  RUBY
end

rails_command('db:migrate')
rails_command('active_storage:install')
rails_command('importmap:install')
rails_command('turbo:install')
rails_command('action_text:install')
rails_command('stimulus:install')
rails_command('db:migrate')

# Setup RSpec and test related config
generate 'rspec:install'
run 'mkdir spec/support'

inject_into_file 'spec/spec_helper.rb', before: "RSpec.configure do |config|\n" do
  <<~'RUBY'
    require "simplecov"
    SimpleCov.start
  RUBY
end

inject_into_file 'spec/rails_helper.rb', before: "require 'rspec/rails'\n" do
  <<~'RUBY'
    require "faker"
    require "capybara/rails"
    Capybara.server = :puma, { Silent: true }
    Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
  RUBY
end

# init guard with rspec config
system('bundle exec guard init rspec')

create_file '.env'

# adds x86_64-linux platform in the Gemfile.lock
run 'bundle lock --add-platform x86_64-linux'

file '.editorconfig', <<~CODE
  root = true

  [*]

  # Change these settings to your own preference
  indent_style = space
  indent_size = 2
  quote_type = single

  # We recommend you to keep these unchanged
  end_of_line = lf
  charset = utf-8
  trim_trailing_whitespace = true
CODE

file '.rubocop.yml', <<~CODE
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

append_file '.gitignore' do
  <<~'GIT'
    /tmp
    /coverage
  GIT
end

generate(:controller, 'welcome index search')
route "root to: 'welcome#index'"
route "post '/', to: 'welcome#search', as: :search"

# run migration
rails_command 'db:migrate'

# setup seeds with default user
inject_into_file 'db/seeds.rb' do
  <<-'RUBY'
  require "faker"
  User.create!(email: Faker::Internet.email, password: 'aassdd123', password_confirmation: 'aassdd123')
  User.create!(email: "admin@test.com", password: 'aassdd123', password_confirmation: 'aassdd123')
  RUBY
end

rails_command 'db:seed'

remove_file 'app/views/devise/sessions/new.html.erb'
remove_file 'app/views/layouts/application.html.erb'
remove_file 'app/views/layouts/devise.html.erb'

create_file 'app/views/devise/sessions/new.html.erb'
create_file 'app/views/layouts/application.html.erb'
create_file 'app/views/layouts/devise.html.erb'

inject_into_file 'app/views/devise/sessions/new.html.erb' do
  <<~'ERB'
    <%= form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>
      <div class="flex flex-row items-center justify-center lg:justify-start">
        <p class="text-lg mb-0 mr-4">Login with credentials</p>
      </div>
      <!-- Email input -->
      <div class="mb-6">
        <%= f.email_field :email, autofocus: true, placeholder: "Email address", autocomplete: "email", class: "form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none" %>
      </div>

      <!-- Password input -->
      <div class="mb-6">
        <%= f.password_field :password, placeholder: "Password", autocomplete: "current-password", class: "form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none" %>
      </div>
      <% if devise_mapping.rememberable? %>
      <div class="flex justify-between items-center mb-6">
        <div class="form-group form-check">
          <%= f.check_box :remember_me, class: "form-check-input appearance-none h-4 w-4 border border-gray-300 rounded-sm bg-white checked:bg-blue-600 checked:border-blue-600 focus:outline-none transition duration-200 mt-1 align-top bg-no-repeat bg-center bg-contain float-left mr-2 cursor-pointer" %>
          <%= f.label :remember_me, class: "form-check-label inline-block text-gray-800" %>
        </div>
      </div>
      <% end %>

      <div class="text-center lg:text-left">
        <button
          type="submit"
          class="inline-block px-7 py-3 bg-blue-600 text-white font-medium text-sm leading-snug uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
        >
          Login
        </button>
      </div>
    <% end %>
  ERB
end

inject_into_file 'app/views/layouts/application.html.erb' do
  <<~'ERB'
    <!DOCTYPE html>
    <html>
      <head>
        <title>Application</title>
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <%= csrf_meta_tags %>
        <%= csp_meta_tag %>

        <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
        <%= javascript_importmap_tags %>
        <script src="https://cdn.tailwindcss.com"></script>

      </head>

      <body>
        <div class="bg-gray-50 h-screen overflow-y-scroll hide-scrollbar">
          <header class="sticky top-0 z-50 bg-red-white shadow-sm grid grid-cols-3 px-10">
            <!-- left content-->
            <div class="relative flex items-center h-20 my-auto">
              <div class="relative items-center hidden lg:inline-grid cursor-pointer"><%= link_to "Project Name", root_path, class: "text-gray-400" %></div>
              <div class="relative items-center lg:hidden w-10 flex-shrink-0 cursor-pointer"><%= link_to "Project Name", root_path, class: "text-gray-400" %></div>
            </div>

            <!-- center content with search -->
            <div class="max-w-xs my-auto">
              <div class="border-2 rounded-full px-6">
                <%= turbo_frame_tag search_path do %>
                  <%= form_with url: search_path, method: :post, class: "flex items-center h-12 justify-between", id: "search_form" do |f| %>
                    <%= text_field_tag :search, "", placeholder: "Busque aqui", class: "bg-transparent outline-none w-[92%]", data: { controller: "welcome", action: "keyup->welcome#search" } %>
                    <%= button_tag heroicon("magnifying-glass", variant: "solid", class: "h-8 w-8 text-white bg-blue-400 rounded-full p-2 cursor-pointer hover:scale-110 transition-all duration-150 ease-out") %>
                  <% end %>
                <% end %>
              </div>
              <div id="results"></div>
            </div>


            <!-- right content with icons -->
            <div class="flex items-center justify-end space-x-4">
              <%= link_to heroicon("arrow-path", variant: "solid", class: "hidden text-gray-400 h-6 md:inline-flex cursor-pointer hover:scale-125 transition-all duration-150 ease-out"), root_path %>

              <div class="flex items-center space-x-2 border-2 rounded-full px-2">
                <%= button_to heroicon("home", variant: "solid", class: "h-6 text-gray-400 cursor-pointer hover:scale-125 transition-all duration-150 ease-out"), root_path, method: :delete, alt: "profile picture", class: "h-10 rounded-full cursor-pointer" %>
                <% if current_user %>
                  <%= button_to heroicon("arrow-right-on-rectangle", variant: "solid", class: "h-6 text-gray-400 cursor-pointer hover:scale-125 transition-all duration-150 ease-out"), destroy_user_session_path, method: :delete, alt: "profile picture", class: "h-10 rounded-full cursor-pointer",  data: { turbo: "false" } %>
                <% else %>
                  <%= link_to heroicon("user-plus", variant: "solid", class: "h-6 text-gray-400 cursor-pointer hover:scale-125 transition-all duration-150 ease-out"), new_user_registration_path, class: "link" %>
                  <%= link_to heroicon("user-circle", class: "h-6 text-gray-400 cursor-pointer hover:scale-125 transition-all duration-150 ease-out"), new_user_session_path, class: "link" %>
                <% end %>
              </div>
            </div>
          </header>
          <main class="container mx-auto p-10">
            <%= yield %>
          </main>
        </div>


        <div class="bg-gray-50 h-screen overflow-y-scroll hide-scrollbar">
          <div class="shadow-sm border-b bg-white sticky top-0 z-50 pb-2 pt-2">
            <header class='flex justify-between max-w-6xl mx-5 lg:mx-auto'>
              <div class="relative items-center hidden lg:inline-grid cursor-pointer"><%= link_to "Project Name", root_path, class: "text-gray-400" %></div>
              <div class="relative items-center lg:hidden w-10 flex-shrink-0 cursor-pointer"><%= link_to "Project Name", root_path, class: "text-gray-400" %></div>

              <div class="max-w-xs">
                <div class="border-2 rounded-full my-auto px-6">
                  <%= turbo_frame_tag search_path do %>
                    <%= form_with url: search_path, method: :post, class: "flex items-center h-12 justify-between", id: "search_form" do |f| %>
                      <%= text_field_tag :search, "", placeholder: "Busque aqui", class: "bg-transparent outline-none w-[92%]", data: { controller: "welcome", action: "keyup->welcome#search" } %>
                      <%= button_tag heroicon("magnifying-glass", variant: "solid", class: "h-8 w-8 text-white bg-blue-400 rounded-full p-2 cursor-pointer hover:scale-110 transition-all duration-150 ease-out") %>
                    <% end %>
                  <% end %>
                </div>
                <div id="results"></div>
              </div>

              <div class="flex items-center justify-end space-x-4">
                <%= link_to heroicon("home", variant: "solid", class: "h-6 hidden md:inline-flex cursor-pointer hover:scale-125 duration-150 ease-out"), root_path %>
                <% if current_user %>
                  <%= button_to heroicon("arrow-right-on-rectangle", variant: "solid", class: "h-6 text-gray-400 cursor-pointer hover:scale-125 transition-all duration-150 ease-out"), destroy_user_session_path, method: :delete, alt: "profile picture", class: "h-10 rounded-full cursor-pointer", data: { turbo: "false" } %>
                <% else %>
                  <%= link_to heroicon("user-plus", variant: "solid", class: "h-6 text-gray-400 cursor-pointer hover:scale-125 transition-all duration-150 ease-out"), new_user_registration_path, class: "link" %>
                  <%= link_to heroicon("user-circle", class: "h-6 text-gray-400 cursor-pointer hover:scale-125 transition-all duration-150 ease-out"), new_user_session_path, class: "link" %>
                <% end %>
              </div>
            </header>
          </div>
          <main class="container mx-auto p-10">
            <%= yield %>
          </main>
        </div>
      </body>
    </html>
  ERB
end

inject_into_file 'app/views/layouts/devise.html.erb' do
  <<~'ERB'
    <!DOCTYPE html>
    <html>
      <head>
        <title>Application</title>
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <%= csrf_meta_tags %>
        <%= csp_meta_tag %>

        <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
        <%= javascript_importmap_tags %>
        <script src="https://cdn.tailwindcss.com"></script>

      </head>

      <body>
        <section class="h-screen">
          <div class="px-6 h-full text-gray-800">
            <div
              class="flex xl:justify-center lg:justify-between justify-center items-center flex-wrap h-full g-6"
            >
              <div
                class="grow-0 shrink-1 md:shrink-0 basis-auto xl:w-6/12 lg:w-6/12 md:w-9/12 mb-12 md:mb-0"
              >
                <img
                  src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-login-form/draw2.webp"
                  class="w-full"
                  alt="Sample image"
                />
              </div>
              <div class="xl:ml-20 xl:w-5/12 lg:w-5/12 md:w-8/12 mb-12 md:mb-0">
              <%= yield %>
              </div>
            </div>
          </div>
        </section>
      </body>
    </html>

  ERB
end

# clear logs
rails_command 'log:clear'

# Fix Rubocop Offences
run 'rm -rf spec/views'
run 'rubocop -A'
