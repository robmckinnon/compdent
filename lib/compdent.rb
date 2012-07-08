require 'mongoid'

module Compdent
end

require File.dirname(__FILE__) + '/config.rb' if File.exist?(File.dirname(__FILE__) + '/config.rb')

require File.dirname(__FILE__) + '/compdent/copyright_parser'
require File.dirname(__FILE__) + '/compdent/page_parser'
require File.dirname(__FILE__) + '/compdent/uri_scraper'
require File.dirname(__FILE__) + '/compdent/twitter'
require File.dirname(__FILE__) + '/compdent/tweeter'
require File.dirname(__FILE__) + '/compdent/twitter_ids'
require File.dirname(__FILE__) + '/compdent/twitter_scraper'
require 'grackle'

ENV['MONGOID_ENV'] ||= 'development'
Mongoid.load!( File.dirname(__FILE__) + "/../mongoid.yml")
