require File.dirname(__FILE__) + '/../lib/compdent'

require 'webmock/rspec' # mock http responses

RSpec.configure do |config|
  config.mock_with :rspec
end
