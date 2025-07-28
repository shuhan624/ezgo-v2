source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.2', '>= 7.2.2'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5', '>= 1.5.8'

# Use Puma as the app server
gem 'puma', '~> 6.4', '>= 6.4.3'

# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'

gem 'sprockets-rails', '~> 3.5', '>= 3.5.2'
gem 'rails-i18n', '~> 7.0', '>= 7.0.9'

# Use Vite for Javascript & CSS
 gem 'vite_ruby', '~> 3.9'
 gem 'vite_rails', '~> 3.0', '>= 3.0.19'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
# gem 'stimulus-rails', '~> 1.3', '>= 1.3.4'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 5.3'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem 'image_processing', '~> 1.13.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'aasm', '~> 5.5' # Order State Machine
gem 'active_storage_validations', '~> 1.3', '>= 1.3.4'
gem 'acts-as-taggable-on', '~> 12.0'
gem 'acts_as_list', '~> 1.2', '>= 1.2.3'
gem 'ahoy_matey', '~> 4.2', '>= 4.2.1'
gem 'amazing_print', '~> 1.5'
gem 'audited', '~> 5.0', '>= 5.0.2'
gem 'bootsnap', '~> 1.11', '>= 1.11.1', require: false
gem 'caxlsx', '~> 3.3'         # Export to Excel
gem 'caxlsx_rails', '~> 0.6.3' # Export to Excel
gem 'cocoon', '~> 1.2', '>= 1.2.15'
gem 'country_select', '~> 8.0', '>= 8.0.1'
gem 'creek', '~> 2.6', '>= 2.6.2' # Import Excel
gem 'csv', '~> 3.3'
gem 'deep_cloneable', '~> 3.2.0'
gem 'devise', '~> 4.8'
gem 'devise-i18n', '~> 1.10'
gem 'dotenv-rails', '~> 2.7', '>= 2.7.6', require: 'dotenv/rails-now'
gem 'draper', '~> 4.0', '>= 4.0.2'
gem 'drb', '~> 2.2', '>= 2.2.1'
gem 'fiddle', '~> 1.1', '>= 1.1.4' # no longer default gems starting from Ruby 3.5.0
gem 'friendly_id', '~> 5.4', '>= 5.4.2'
gem 'google-analytics-data', '~> 0.5.0', require: false
gem 'line-bot-api', '~> 1.29.1'
gem 'meta-tags', '~> 2.16'
gem 'mobility', '~> 1.2', '>= 1.2.9' # i18n in database
gem 'omniauth-line', '~> 0.2.1', github: 'BackerFounder/omniauth-line'
gem 'omniauth-rails_csrf_protection', '~> 1.0', '>= 1.0.1'
gem 'ostruct', '~> 0.6.0' # no longer default gems starting from Ruby 3.5.0
gem 'pagy', '~> 4.10', '>= 4.10.1'
gem 'paranoia', '~> 3.0'
gem 'pry', '~> 0.14.2'
gem 'pry-rails', '~> 0.3.9' # open rails console using pry
gem 'pundit', '~> 2.2'
gem 'rails_cloudflare_turnstile', '~> 0.2.1'
gem 'ransack', '~> 4.2', '>= 4.2.1'
gem 'roo', '~> 2.10', '>= 2.10.1' # for Excel import
gem 'simple_form', '~> 5.1'
gem 'sitemap_generator', '~> 6.2', '>= 6.2.1'
gem 'whenever', require: false
gem 'awesome_nested_set', '~> 3.8'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.4'
  gem 'ffaker', '~> 2.23'
  gem 'parallel_tests', '~> 4.7', '>= 4.7.2'
  gem 'pry-byebug', '~> 3.10', '>= 3.10.1'
  gem 'rspec-rails', '~> 7.1'
  gem 'shoulda-matchers', '~> 6.4'
end

group :development do
  gem 'annotate', '~> 3.2'
  gem 'bullet', '~> 8.0'
  gem 'colorize', '~> 1.1'
  gem 'foreman', '~> 0.87.2'
  gem 'guard-rspec', '~> 4.7', '>= 4.7.3'
  gem 'listen', '~> 3.3'
  gem 'mina', '~> 1.2', '>= 1.2.4'

  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 3.3', '>= 3.3.1'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 4.2', '>= 4.2.1'

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '~> 4.2'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.40'
  gem 'capybara-email', '~> 3.0', '>= 3.0.2'
  gem 'database_cleaner-active_record', '~> 2.1'
  gem 'selenium-webdriver', '~> 4.27'
  gem 'timecop', '~> 0.9.10'
  gem 'webmock', '~> 3.24'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
