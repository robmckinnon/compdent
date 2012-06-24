require 'active_support/core_ext/array/grouping'

module Compdent

  class TwitterScraper

    def initialize screen_name
      @screen_name = screen_name
      @twitter = Twitter.new
    end

    def retrieve
      tweeter = Tweeter.from_screen_name @screen_name

      following_ids = @twitter.following_ids(@screen_name)

      if tweeter.following_ids != following_ids
        tweeter.following_ids = following_ids
        @twitter.each_lookup(following_ids) do |data|
        end
        tweeter.save
      end

      tweeter
    end

  end

end
