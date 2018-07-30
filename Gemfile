source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.6'
gem 'bcrypt', '3.1.11'
gem 'bootstrap-sass', '~> 3.3.7'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

group :development, :test do
  gem 'rspec-rails', '~> 3.6.0'
  gem 'sqlite3'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
  gem 'guard-rspec', require: false
  gem 'factory_bot_rails', '~> 4.10.0'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'faker', require: false # for sample data in development
  gem 'spring-commands-rspec'
end

group :test do
  gem 'selenium-webdriver'
  gem 'capybara', '~> 2.15.4'
# 	gem 'chromedriver-helper'
# 	# Or use poltergeist and PhantomJS as an alternative to Selenium/Chrome
# 	# gem 'poltergeist', '~> 1.15.0'
# 	gem 'launchy', '~> 2.4.3'
# 	gem 'shoulda-matchers',
# 	    git: 'https://github.com/thoughtbot/shoulda-matchers.git',
# 	    branch: 'rails-5'
# 	gem 'vcr'
# 	gem 'webmock'
end

group :production do
  gem 'pg'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'jquery-rails'
gem 'devise'
gem 'paperclip'
gem 'geocoder'

