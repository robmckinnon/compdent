module Compdent

  # API to Twitter
  class Twitter

    def initialize throttle_delay_in_seconds, recovery_delay_in_seconds
      @throttle_delay_in_seconds = throttle_delay_in_seconds
      @recovery_delay_in_seconds = recovery_delay_in_seconds

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
      perform { @twitter.friends.ids?(:screen_name => screen_name).ids }
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
      perform { @twitter.users.lookup!(:user_id => user_ids.join(',')) }
    end

    protected

    def perform
      begin
        items = yield
        Kernel.sleep(@throttle_delay_in_seconds)
        items
      rescue Exception => exception
        Kernel.sleep(@recovery_delay_in_seconds)
        []
      end
    end

  end

end
