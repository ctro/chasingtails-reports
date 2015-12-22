source 'https://rubygems.org'

ruby "2.2.4"

gem 'dotenv-rails'
gem 'rails', '4.2.5'
gem 'pg'

# Clay-land
gem 'sass-rails', '~> 4.0.0'
gem 'bourbon'
gem 'bitters'

# Front end
gem 'will_paginate'

# JS
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'  # compress js
gem 'coffee-rails', '~> 4.0.0'   # we are using coffee: reports.js.coffee.erb

# Auth
gem 'devise'
gem 'cancan'
gem "paranoia", "~> 2.0"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# Weird, there are .jbuilder templates.  there is no external api is there?
gem 'jbuilder', '~> 1.2'

# Image uploads.
gem "refile", require: "refile/rails"
gem "refile-mini_magick"
gem "refile-s3"

gem 'aws-sdk'

group :production do
  gem 'puma'
end

group :development do
  gem 'thin'
	gem 'annotate'
	gem 'pry'
end
