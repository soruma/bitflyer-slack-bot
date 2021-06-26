# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '~> 2.7.0'

gem 'aws-sdk-dynamodb'
gem 'bitflyer'
gem 'slack-ruby-client'

group :test do
  gem 'rspec'

  gem 'vcr'
  gem 'webmock'
end

group :test, :development do
  gem 'rubocop'
  gem 'rubocop-rspec'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
end
