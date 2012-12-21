source 'https://rubygems.org'

gem 'nokogiri'
gem 'mongoid' # model and repository framework
gem 'grackle' # wrapper around Twitter REST and Search APIs
gem 'morph'
gem 'json'

group :test do
  gem 'rspec'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-rspec'
  gem 'webmock'
end

group :development do
  gem 'fattr'
  gem 'arrayfields'
  gem 'map'
  gem 'metrical'
end

gem 'rake' # required for travis builds
