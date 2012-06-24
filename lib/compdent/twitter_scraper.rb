require 'active_support/core_ext/array/grouping'

module Compdent

  # Scrapes Twitter account information
  class TwitterScraper

    def initialize screen_name
      @screen_name = screen_name
      @twitter = Twitter.new
    end

    def retrieve
      tweeter = Tweeter.from_screen_name(@screen_name)

      tweeter.following_ids = @twitter.following_ids(@screen_name)

      if tweeter.following_ids_changed?
        retrieve_following(tweeter.following_ids)
        tweeter.save
      end

      tweeter
    end

    def retrieve_following following_ids
      ids = TwitterIds.new(following_ids).new_ids

      @twitter.each_lookup(ids) do |data|
        tweeter = Tweeter.from_user_id data.id
        tweeter.update_data data
      end
    end
  end

end
