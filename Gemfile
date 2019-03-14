source 'https://rubygems.org'

# Match to prod server
ruby '~> 2.3'

gem 'dotenv-rails', '~> 2.7'
gem 'pg', '~> 0.21'
gem 'rails', '~> 4.2'

# Clay-land
gem 'bitters', '~> 1.0'
gem 'bourbon', '~> 3.2'
gem 'sass-rails', '~> 4.0'

# Front end
gem 'will_paginate', '~> 3.1'

# JS
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails', '~> 4.3'
gem 'uglifier', '~> 3.2'

# Auth
gem 'cancan', '~> 1.6'
gem 'devise', '~> 4.6'
gem 'paranoia', '~> 2.4'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# Weird, there are .jbuilder templates.  there is no external api is there?
gem 'jbuilder', '~> 1.5'

# Image uploads.
gem 'refile', '~> 0.6', require: 'refile/rails'
gem 'refile-mini_magick', '~> 0.2'
gem 'refile-s3', '~> 0.2'

gem 'aws-sdk', '~> 2.11'
gem 'aws-ses', '~> 0.6', require: 'aws/ses'

# Pry, always
gem 'pry', '~> 0.12'

gem 'skylight', '~> 1.7'

group :production do
  gem 'puma', '~> 3.12'
end

group :development do
  gem 'annotate', '~> 2.7'
  gem 'brakeman', '~> 4.4'
  gem 'guard', '~> 2.15'
  gem 'guard-minitest', '~> 2.4'
  gem 'pessimize', '~> 0.4'
  gem 'rubocop', '~> 0.65'
  gem 'terminal-notifier-guard', '~> 1.7'
  gem 'thin', '~> 1.7'
end

group :test do
  gem 'minitest', '~> 5.11'
  gem 'minitest-reporters', '~> 1.3'
  gem 'simplecov', '~> 0.16'
end
