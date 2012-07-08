require 'active_support/core_ext/array/grouping'

module Compdent

  # represents Twitter account information
  class Tweeter

    include Mongoid::Document

    field :user_id, :type => Integer
    field :screen_name, :type => String
    field :name, :type => String
    field :url, :type => String
    field :following_ids, :type => Array

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
      { :name => @data.name,
        :screen_name => @data.screen_name,
        :url => @data.url }
    end
  end
end
