require 'active_support/core_ext/array/grouping'

module Compdent

  class TwitterScraper

    def initialize screen_name
      @screen_name = screen_name
      @twitter = Twitter.new
    end

    def retrieve
      tweeter = Tweeter.from_screen_name @screen_name

      unless tweeter
        following_ids = @twitter.following_ids(@screen_name)
        tweeter = Tweeter.new(:screen_name => @screen_name, :following_ids => following_ids)

        @twitter.each_lookup(following_ids) { }
        tweeter.save
      end

      tweeter
    end

  end

  class Tweeter

    include Mongoid::Document

    field :user_id, type: Integer
    field :screen_name, type: String
    field :following_ids, type: Array

    attr_readonly :user_id

    class << self
      def from_screen_name name
        where(:screen_name => name).first
      end
    end
  end
end
