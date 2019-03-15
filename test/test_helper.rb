# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
ENV['S3_BUCKET'] = 'tails-test'

if ENV['COVERAGE']
  # Simplecov FIRST
  require 'simplecov'
  SimpleCov.start 'rails'
end

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  fixtures :all
end

WillPaginate.per_page = 5
