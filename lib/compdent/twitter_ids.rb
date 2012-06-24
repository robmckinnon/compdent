module Compdent

  # holds collection of Twitter ids
  class TwitterIds

    def initialize ids
      @ids = ids
    end

    def new_ids
      @ids.select {|id| !Tweeter.user_id_exists?(id) }
    end
  end
end
