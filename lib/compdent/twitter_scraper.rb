require 'active_support/core_ext/array/grouping'

class Compdent::TwitterScraper

  def initialize screen_name
    @screen_name = screen_name
    @twitter = Grackle::Client.new
  end

  def retrieve
    tweeter = Compdent::Tweeter.where(:screen_name => @screen_name).first

    unless tweeter
      tweeter = Compdent::Tweeter.new(:screen_name => @screen_name,
        :following_ids => following_ids)

      lookup following_ids
      tweeter.save
    end

    tweeter
  end

  protected

  def lookup following_ids
    following_ids.in_groups_of(100, false) do |user_ids|
      result = @twitter.users.lookup!(:user_id => user_ids.join(','))
      result
    end
  end

  def following_ids
    result = @twitter.friends.ids?(:screen_name => @screen_name)
    result.ids
  end

end

class Compdent::Tweeter

  include Mongoid::Document

  field :user_id, type: Integer
  field :screen_name, type: String
  field :following_ids, type: Array

  attr_readonly :user_id
end

