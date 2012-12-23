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
        page = find_or_create_by(:uri => canonical_uri(uri))
        page.retrieve_content
        page
      end
    end

    def retrieve_content
      if content_to_retrieve? && (body = UriScraper.get_response_body(uri))
        begin
          if body.size > 0
            update_attribute(:content, body)
            puts uri if content
          end
        rescue Exception => e
          puts e.to_s
          puts e.backtrace.join("\n")
        end
      end
    end

    private

    def content_to_retrieve?
      host_uri? && content.nil?
    end

    def host_uri?
      Uri.new(uri).host_uri?
    end
  end

  class Uri

    def initialize uri
      @uri = URI(uri)
    end

    def canonical
      if @uri.path == ""
        if @uri.query
          "#{@uri.scheme}://#{@uri.host}/?#{@uri.query}"
        else
          "#{@uri.scheme}://#{@uri.host}/"
        end
      else
        @uri.to_s
      end
    end

    def host_uri?
      (@uri.path == '' || @uri.path == '/') && @uri.query == nil
    end
  end

end
