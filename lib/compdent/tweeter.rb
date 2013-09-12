require 'active_support/core_ext/array/grouping'
require 'url_expander'
module Compdent

  # represents Twitter account information
  class Tweeter

    include Mongoid::Document

    field :user_id, :type => Integer
    field :screen_name, :type => String
    field :name, :type => String
    field :url, :type => String
    field :following_ids, :type => Array

    field :description, :type => String
    field :location, :type => String

    attr_readonly :user_id

    index({ :user_id => 1 }, :unique => true, :name => 'user_id_index' )

    class << self

      def user_id_exists? user_id
        where(:user_id => user_id).exists?
      end

      def from_screen_name name
        find_or_create_by(:screen_name => name)
      end

      def from_user_id user_id
        find_or_create_by(:user_id => user_id)
      end

      def needs_update following_ids
        following_ids.map do |id|
          tweeter = where(user_id: id).first
          if tweeter && tweeter.url && tweeter.url[/co.uk(\/|$)/] && tweeter.following_ids.nil?
            tweeter
          else
            nil
          end
        end.compact
      end

    end

    def update_data data
      write_attributes TweeterData.new(data).hash
      save
    end

    def has_following_ids?
      !following_ids.nil?
    end

    def has_co_uk_url?
      url.to_s[/co.uk/]
    end
  end

  # temp holder of data
  class TweeterData
    def initialize data
      @data = data
    end

    def hash
      begin
        url = @data.url.blank? ? nil : UrlExpander::Client.expand(@data.url)
      rescue Exception => e
        puts e.to_s
        puts @data.url
        url = @data.url
      end
      attributes = { :name => @data.name, :screen_name => @data.screen_name, :url => url }
      attributes.merge!({ :description => @data.description, :location => @data.location }) if url
      attributes
    end
  end
end
