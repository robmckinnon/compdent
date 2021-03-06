require 'active_support/core_ext/array/grouping'

module Compdent

  # Scrapes Twitter account information
  class TwitterScraper

    class << self

      def setup
        @retrieving ||= {}
        @retrieved ||= {}
      end

      def retrieve_from options
        setup
        unless @retrieving[options]
          @retrieving[options] = true
          scraper = TwitterScraper.new(options)
          tweeter = scraper.retrieve
          retrieve_following tweeter.following_ids
        end
      end

      def retrieve_following following_ids
        puts "following_ids: #{following_ids}" unless (ENV['MONGOID_ENV'] == 'test')
        to_update = Tweeter.needs_update(following_ids)
        to_update.each do |tweeter|
          @tweeter = tweeter
          id = @tweeter.user_id
          unless @retrieved[id]
            log
            @retrieved[id] = true
            TwitterScraper.retrieve_from(:user_id => id)
          end
        end
      end

      def log
        puts "#{@tweeter.screen_name} --- #{@tweeter.url.to_s} --- #{@tweeter.user_id}" unless (ENV['MONGOID_ENV'] == 'test')
      end
    end

    def initialize options
      screen_name = options[:screen_name]

      @tweeter = if screen_name
                   Tweeter.from_screen_name(screen_name)
                 else
                   Tweeter.from_user_id(options[:user_id])
                 end
      @twitter = Twitter.new(3, 5 * 60)
      @options = options
    end

    def retrieve
      unless @tweeter.has_following_ids?
        @tweeter.following_ids = @twitter.following_ids(@options)

        if @tweeter.following_ids_changed?
          retrieve_following(@tweeter.following_ids)
          @tweeter.save
        end
      end

      @tweeter
    end

    def retrieve_following following_ids
      ids = TwitterIds.new(following_ids).new_ids

      @twitter.each_lookup(ids) do |data|
        @following = Tweeter.from_user_id(data.id)
        update_following(data)
      end
      nil
    end

    def update_following data
      @following.update_data data
      puts "  #{@following.screen_name} --- #{@following.url.to_s}" unless (ENV['MONGOID_ENV'] == 'test')
      nil
    end
  end

end
