
class TwitterScraper

  attr_accessor :screen_name

  def initialize name
    @screen_name = name
    @twitter = Grackle::Client.new
  end

  def following_ids
    result = @twitter.friends.ids?(:screen_name => @screen_name)
    result.ids
  end

end
