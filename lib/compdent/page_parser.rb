require 'nokogiri'

module Compdent
  # Calls callbacks when interesting stuff found in page
  class PageParser
    def initialize listener
      @listener = listener
      @parser = Nokogiri::HTML::SAX::Parser.new(self)
    end

    def parse html, base_uri
      @base_uri = URI(base_uri)
      @parser.parse(html)
    end

    def start_document
    end

    def start_element name, attributes
      if name == 'a'
        href = attributes.assoc('href').try(:last)
        @href = href ? @base_uri.merge(href).to_s : nil
        @state = :link
      end
    end

    def characters characters
      if @state = :link
        @characters ||= ''
        @characters += characters
      end
    end

    def end_element name
      if @state = :link && name == 'a'
        if @characters[/Contact us/]
          @listener.contact_us_uri(@href)
        elsif @characters[/About us/]
          @listener.about_us_uri(@href)
        end
        @state = nil
      end
    end

    def end_document
    end
  end
end
