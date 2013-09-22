require 'uri'
require 'fileutils'

module Compdent

  # represents Web page information
  class WebPage

    include Mongoid::Document

    field :uri, :type => String
    field :content, :type => String
    field :has_opening_times, :type => Boolean
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
            u = Uri.new(uri)
            dir = "./data/#{u.tld}/#{u.hostname[0..0]}"
            FileUtils.mkdir_p(dir) unless Dir.exists?(dir)
            filename = "#{dir}/#{u.host.gsub('/','_')}"
            File.open(filename,'w') { |f| f.write body }
            update_attribute(:content, filename)
            puts uri if content
            puts filename if content
            puts '--'
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

    def tld
      host.split('.')[-1]
    end

    def hostname
      host.split('.')[-2]
    end

    def host
      @uri.host
    end
  end

end
