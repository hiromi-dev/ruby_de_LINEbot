# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'
gem 'jbuilder', '~> 2.7'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.0'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'line-bot-api'
gem 'dotenv'

group :development, :test do
  gem 'pry-rails'
  gem 'pry', '~> 0.13.1'
  gem 'byebug', '~> 11.1', '>= 11.1.3'
  gem 'pry-byebug', '~> 3.4'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
