
class Compdent::TwitterScraper

  def initialize screen_name
    @screen_name = screen_name
    @twitter = Grackle::Client.new
  end

  def retrieve
    Compdent::Tweeter.new :screen_name => @screen_name,
    :following_ids => following_ids
  end

  protected

  def following_ids
    result = @twitter.friends.ids?(:screen_name => @screen_name)
    result.ids
  end

end

class Compdent::Tweeter
  include Curator::Model

  attr_accessor :id, :screen_name, :following_ids

end
