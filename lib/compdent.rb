require 'curator'

# Curator.configure(:memory) do |config|
  # config.environment = 'test'
  # config.migrations_path = File.expand_path(File.dirname(__FILE__) + "/../db/migrate")
# end

module Compdent
end

require File.dirname(__FILE__) + '/compdent/twitter_scraper'
require 'grackle'

