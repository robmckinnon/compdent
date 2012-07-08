module Compdent

  # API to Twitter
  class Twitter

    def initialize
      @twitter = if defined?(TWITTER_CONSUMER_KEY) && (ENV['MONGOID_ENV'] != 'test')
        Grackle::Client.new(
          :auth => {
            :type => :oauth, :consumer_key => TWITTER_CONSUMER_KEY,
            :consumer_secret => TWITTER_CONSUMER_SECRET,
            :token => TWITTER_OAUTH_TOKEN,
            :token_secret => TWITTER_OAUTH_SECRET_TOKEN
          }
        )
      else
        Grackle::Client.new
      end
    end

    def following_ids screen_name
      result = @twitter.friends.ids?(:screen_name => screen_name)
      result.ids
    end

    def each_lookup following_ids, &block

      following_ids.in_groups_of(100, false) do |user_ids|
        yield_items user_ids, &block
      end

    end

    def yield_items user_ids
      users_lookup(user_ids).each do |item|
        yield item
      end
    end

    def users_lookup user_ids
      @twitter.users.lookup!(:user_id => user_ids.join(','))
    end
  end
end
