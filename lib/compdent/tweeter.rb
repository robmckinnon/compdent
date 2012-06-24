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

    class << self
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
