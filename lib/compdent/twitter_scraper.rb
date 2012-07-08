require 'active_support/core_ext/array/grouping'

module Compdent

  # Scrapes Twitter account information
  class TwitterScraper

    class << self
      def retrieve options
        @retrieving ||= {}
        return if @retrieving[options]

        @retrieving[options] = true
        @retrieved ||= {}
        tweeter = TwitterScraper.new(options).retrieve
        puts tweeter.screen_name + " --- " + tweeter.url.to_s

        tweeter.following_ids.reverse.each do |id|
          unless @retrieved[id]
            tweeter = Tweeter.from_user_id(id)
            if tweeter.url && tweeter.url[/co.uk/]
              TwitterScraper.retrieve :user_id => id
            end
            @retrieved[id] = true
          end
        end
      end
    end

    def initialize options
      @tweeter = if options[:screen_name]
                   Tweeter.from_screen_name(options[:screen_name])
                 else
                   Tweeter.from_user_id(options[:user_id])
                 end
      @twitter = Twitter.new
      @options = options
    end

    def retrieve
      if @tweeter.following_ids.nil?
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
        tweeter = Tweeter.from_user_id data.id
        tweeter.update_data data
        puts "  " + tweeter.screen_name + " --- " + tweeter.url.to_s
      end
    end
  end

end
