require 'mongoid'

module Compdent
end

require File.dirname(__FILE__) + '/compdent/web_page'
require File.dirname(__FILE__) + '/compdent/copyright_parser'
require File.dirname(__FILE__) + '/compdent/page_parser'
require File.dirname(__FILE__) + '/compdent/uri_scraper'
require File.dirname(__FILE__) + '/compdent/twitter'
require File.dirname(__FILE__) + '/compdent/tweeter'
require File.dirname(__FILE__) + '/compdent/twitter_ids'
require File.dirname(__FILE__) + '/compdent/twitter_scraper'
require 'grackle'

ENV['MONGOID_ENV'] ||= 'development'
Mongoid.load!( File.dirname(__FILE__) + "/../config/mongoid.yml")
require File.dirname(__FILE__) + "/../config/twitter" if File.exist?(File.dirname(__FILE__) + "/../config/twitter.rb")
