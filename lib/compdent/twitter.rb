module Compdent

  # API to Twitter
  class Twitter

    def initialize recovery_delay_in_seconds=(5*60)
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

      @recovery_delay_in_seconds = recovery_delay_in_seconds
    end

    def following_ids options
      begin
        sleep 5
        result = @twitter.friends.ids?(options)
        result.ids
      rescue Exception => e
        puts "options: #{options.inspect}: #{e.to_s}"
        puts e.to_s
        Kernel.sleep(@recovery_delay_in_seconds)
        []
      end
    end

    # yields data item for each user
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
      user_ids_list = user_ids.join(',')

      begin
        sleep 5
        @twitter.users.lookup!(:user_id => user_ids_list)
      rescue Exception => e
        puts "user_ids: #{user_ids_list}: #{e.to_s}"
        $stdout.flush
        Kernel.sleep(@recovery_delay_in_seconds)
        []
      end
    end
  end
end
