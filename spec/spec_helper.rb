require File.dirname(__FILE__) + '/../lib/compdent'

ENV['MONGOID_ENV'] = 'test'
Mongoid.load!( File.dirname(__FILE__) + "/../mongoid.yml")

require 'webmock/rspec' # mock http responses

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:suite) do
  end

  config.after(:each) do
  end
end
