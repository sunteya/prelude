source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.2'
gem 'rails-i18n', '5.0.3'
gem 'pg'

# Core
gem 'cancancan', '1.16.0'
gem 'fume-cancan', '0.1.0'
gem 'devise', '4.2.1'
gem 'devise-i18n', '1.1.2'
gem 'devise_invitable', '1.7.2'

# Model
gem 'ransack', '1.8.2'
gem 'enumerize', '2.1.0'

# View
gem 'kaminari', '1.0.1'
gem 'kaminari-bootstrap', '3.0.1'
gem 'simple_form', '3.4.0'
gem 'jbuilder', '~> 2.5'
gem 'responders', '2.3.0'
gem 'fume-nav', '0.0.3'

# Utils
gem 'fume-settable', '0.0.3'
gem 'whenever', '0.9.7'

# Assets
gem 'webpacker', github: 'rails/webpacker', ref: "7b83822"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'pry-rails'
  gem 'pry-byebug'

  gem 'rspec-rails', '3.5.2'
  gem 'factory_girl_rails', '4.8.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Use Puma as the app server
  gem 'puma', '~> 3.0'

  gem 'annotate'
  gem 'capsum', '>= 1.0.7', require: false
end

group :test do
  gem 'rails-controller-testing', '1.0.1'
  gem 'shoulda-matchers', '3.1.1'
  gem 'rspec-do_action', '0.0.4'
  gem 'rspec-its', '1.2.0'
  gem 'simplecov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
