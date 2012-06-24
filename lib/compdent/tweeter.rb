require 'active_support/core_ext/array/grouping'

module Compdent

  class Tweeter

    include Mongoid::Document

    field :user_id, type: Integer
    field :screen_name, type: String
    field :following_ids, type: Array

    attr_readonly :user_id

    class << self
      def from_screen_name name
        find_or_create_by(:screen_name => name)
      end

      def from_user_id user_id
        find_or_create_by(:user_id => user_id)
      end
    end
  end
end
