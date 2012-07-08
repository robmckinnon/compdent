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

      def from_uri uri
        uri = Uri.new(uri)

        page = find_or_create_by(:uri => uri.canonical)

        if uri.host_uri? && page.content.nil?
          content = UriScraper.get_response_body(uri.canonical)
          if content && content.size > 0
            puts uri.canonical
            page.content = content
            page.save
          end
        end
        page
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

    def host_uri?
      @uri.path == '' && @uri.query == nil
    end
  end

end
