require 'mongoid'

module Compdent
end

require File.dirname(__FILE__) + '/compdent/twitter_scraper'
require 'grackle'

ENV['MONGOID_ENV'] = 'development'
Mongoid.load!( File.dirname(__FILE__) + "/../mongoid.yml")
