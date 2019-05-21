# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'apipie-rails', '~> 0.5.8'
gem 'health_check', '~> 3.0.0'
gem 'httparty', '~> 0.17.0'
gem 'jbuilder', '~> 2.8.0'
gem 'jbuilder_pagination_plus', '~> 1.0.0', require: 'jbuilder/pagination'
gem 'jwt', '~> 2.1.0'
gem 'kaminari', '~> 1.1.1'
gem "lograge"
gem 'maruku', '~> 0.7.3'
gem 'oj', '~> 3.7.12'
gem 'pg', '>= 0.18', '< 2.0'
gem 'pg_search', '~> 2.1.2'
gem 'puma', '~> 3.11'
gem 'pundit', '~> 2.0.1'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.2.0'

group :development, :test do
  gem 'bullet'
  gem 'dotenv-rails'
  gem 'faker', '~> 1.9.3'
  gem 'guard'
  gem 'guard-brakeman'
  gem 'guard-minitest'
  gem 'guard-rubocop'
  gem 'guard-shell'
  gem 'httplog', '~> 1.2.2'
  gem 'minitest-ci'
  gem 'minitest-reporters'
  gem 'policy-assertions', '~> 0.2.0'
  gem 'rubocop', '~> 0.68.1'
  gem 'rubocop-performance', '~> 1.2.0'
  gem 'simplecov', require: false
end

group :development do
  gem 'annotate', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'newrelic_rpm'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
