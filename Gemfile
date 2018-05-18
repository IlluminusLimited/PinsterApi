# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end
gem 'apipie-rails', '~> 0.5.7'
gem 'health_check', '~> 3.0.0'
gem 'jbuilder', '~> 2.7.0'
gem 'maruku', '~> 0.7.3'
gem 'newrelic_rpm'
gem 'oauth2', '~> 1.4.0'
gem 'oj', '~> 3.5.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'pg_search', '~> 2.1.2'
gem 'puma', '~> 3.11'
gem 'pundit', '~> 1.1.0'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.1.6'
gem 'sorcery', '~> 0.12'

group :development, :test do
  gem 'bullet'
  gem 'faker'
  gem 'guard'
  gem 'guard-brakeman'
  gem 'guard-minitest'
  gem 'guard-rubocop'
  gem 'guard-shell'
  gem 'minitest-ci'
  gem 'minitest-reporters'
  gem 'policy-assertions', '~> 0.1.1'
  gem 'rubocop'
  gem 'simplecov', require: false
end

group :development do
  gem 'annotate', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
