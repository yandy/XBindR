source 'http://ruby.taobao.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'resque', "~> 1.20.0"

gem "settingslogic", "~> 2.0.6"
gem 'formtastic', "~> 2.2"
gem 'formtastic-bootstrap', '~> 2.0.0'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
gem 'jbuilder'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bioinformatics
gem 'bio'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'anjlab-bootstrap-rails', '~> 3.0.2.0', :require => 'bootstrap-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem "therubyracer", :require => 'v8' unless RUBY_PLATFORM =~ /darwin/i

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development do
  # Haml templates system
  gem 'haml-rails', '>= 0.3.4'
  gem 'sqlite3'
  gem 'pry'
end

group :production do
  gem 'haml', "~> 3.1.4"

  # Use unicorn as the app server
  gem 'unicorn'
end
