
class Compdent::TwitterScraper

  def initialize screen_name
    @screen_name = screen_name
    @twitter = Grackle::Client.new
  end

  def retrieve
    tweeter = Compdent::TweeterRepository.find_first_by_screen_name(@screen_name)

    unless tweeter
      tweeter = Compdent::Tweeter.new(:screen_name => @screen_name,
        :following_ids => following_ids)
      Compdent::TweeterRepository.save(tweeter)
    end

    tweeter
  end

  protected

  def following_ids
    result = @twitter.friends.ids?(:screen_name => @screen_name)
    result.ids
  end

end

class Compdent::Tweeter

  include Curator::Model

  attr_accessor :id, :user_id, :screen_name, :following_ids

end

class Compdent::TweeterRepository

  include Curator::Repository

  indexed_fields :screen_name, :user_id

end
