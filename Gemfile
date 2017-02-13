source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'

group :development do
  # Use mysql as the database for Active Record
  gem 'mysql2', '>= 0.3.13', '< 0.5'
end

group :production do
  # Use postgresql as the database for Active Record
  gem 'pg'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# The templating engine
gem 'haml-rails', '~> 0.9'

# Add a comment summarizing the current schema to the top of model
gem 'annotate'

# Use for authentication
gem 'devise'

# Strategy to authenticate with Google via OAuth2 in OmniAuth.
gem 'omniauth-google-oauth2'

# Use for load environment variables from `.env`
gem 'dotenv-rails'

# Google Client Library
gem 'google-api-client'

# Use for interface to Google's Gmail
gem 'gmail'

# Enumerated attributes
gem 'enumerize'

# Use for handle nested forms
gem 'cocoon'

# Brings Rails named routes to javascript
gem 'js-routes'

# This is Bootstrap 3
gem 'bootstrap-sass'

# Font Awesome
gem 'font-awesome-rails'

# Use for views template
gem 'mustache'

# User for handle markdown
gem 'redcarpet'

# User for pagination
gem 'kaminari'

# Use for slugging and permalink
gem 'friendly_id'

# for sending notifications when errors occur
gem 'exception_notification'

# Use for background processing
gem 'sidekiq'
gem 'sinatra', require: false
# gem 'sidekiq-status'

# webserver
gem 'puma'

# provides an easy-to-use interface for managing your data
gem 'rails_admin'

# authorization library
gem 'cancancan'

# PDF generation
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # handle for debugging
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'

  # for code optimization
  gem 'rubycritic', require: false
  gem 'rails_best_practices'
  gem 'bullet'
  gem 'rubocop', require: false
  gem 'rack-mini-profiler', require: false
end

