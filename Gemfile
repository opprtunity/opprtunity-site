require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :development do
  gem "guard-livereload"
  gem "yajl-ruby"
  gem "rack-livereload"
  gem "guard-bundler"
  gem "guard-rspec"
  gem "guard-unicorn"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'sextant'
  gem 'quiet_assets'
  gem 'thin'
end

gem "pg"
gem 'postgres_ext', '0.2.2'
gem "rspec-rails", :group => [:development, :test]
gem 'rocket_pants', '~> 1.0'
gem 'factory_girl_rails'
gem 'will_paginate', '~> 3.0'
gem 'area', '0.10.0'
gem 'geocoder'

group :assets do
  gem "twitter-bootstrap-rails", '2.2.3'
  gem "therubyracer", '0.11.3'
end

gem "less-rails", '2.2.6'
gem "simple_form", '2.0.4'
gem "unicorn", '4.6.0'
gem 'localstorageshim-rails', '1.0.2'
gem 'omniauth-linkedin', '0.0.8'
gem 'linkedin', '0.3.7'
gem "fuelux-rails", '2.2.0'
gem "select2-rails", '3.2.1'
gem 'sucker_punch', '0.2'