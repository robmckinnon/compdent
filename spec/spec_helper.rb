require File.dirname(__FILE__) + '/../lib/compdent'

require 'webmock/rspec' # mock http responses

Curator.configure(:memory) do |config|
  config.environment = 'test'
  config.migrations_path = File.expand_path(File.dirname(__FILE__) + "/../db/migrate")
end

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:suite) do
    Curator.data_store.remove_all_keys
  end

  config.after(:each) do
    Curator.data_store.reset!
  end
end
