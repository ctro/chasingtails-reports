source 'https://rubygems.org'

ruby "2.0.0"

gem 'dotenv-rails'
gem 'rails', '4.0.2'
gem 'pg'

# Clay-land
gem 'sass-rails', '~> 4.0.0'
gem 'bourbon'
gem 'bitters'

# Front end
gem 'simple_form'
gem 'will_paginate'

# JS
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'  # compress js
gem 'coffee-rails', '~> 4.0.0'   # we are using coffee: reports.js.coffee.erb

# Auth
gem 'devise'
gem 'cancan'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# Weird, there are .jbuilder templates.  there is no external api is there?
gem 'jbuilder', '~> 1.2'

# Image uploads.
gem 'paperclip'  # -> refile  Signed Uploads, js caching.  Still need jquery?
gem 'aws-sdk'

group :production do
  gem 'puma'
  gem 'exception_notification'
end

group :development do
  gem 'thin'
	gem 'annotate'
	gem 'pry'
end
