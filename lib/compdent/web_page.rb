require 'uri'

module Compdent

  # represents Web page information
  class WebPage

    include Mongoid::Document

    field :uri, :type => String
    field :content, :type => String

    attr_readonly :uri

    index({ :uri => 1 }, :unique => true, :name => 'uri_index' )

    class << self
      def canonical_uri uri
        Uri.new(uri).canonical
      end
    end
  end

  class Uri

    def initialize uri
      @uri = URI(uri)
    end

    def canonical
      if @uri.path == ""
        query = @uri.query
        "#{@uri.scheme}://#{@uri.host}/#{query ? '?' + query : ''}"
      else
        @uri.to_s
      end
    end
  end

end
