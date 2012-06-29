# encoding: utf-8
require 'nokogiri'

module Compdent

  # Calls callbacks when interesting stuff found in page
  class PageParser
    def initialize listener
      @listener = listener
      @parser = Nokogiri::HTML::SAX::Parser.new(self)
      @states = []
    end

    def parse html, base_uri
      @base_uri = URI(base_uri)
      @parser.parse(html)
    end

    def start_document
    end

    def start_element name, attributes
      case name
      when 'a'
        handle_anchor attributes
      when 'p'
        handle_paragraph
      else
        nil
      end
    end

    def handle_paragraph
      @states << :paragraph
    end

    def handle_anchor attributes
      href = attributes.assoc('href').try(:last)
      @href = href ? @base_uri.merge(href).to_s : nil
      @states << :link
    end

    def characters characters
      case @states.last
      when :link
        @link_text ||= ''
        @link_text += characters
      when :paragraph
        @paragraph ||= ''
        @paragraph += characters
      else
        nil
      end
    end

    def end_element name
      case @states.last
      when :link
        finish_anchor if name == 'a'
      when :paragraph
        finish_paragraph if name == 'p'
      else
        nil
      end
    end

    def finish_paragraph
      case URI.escape(@paragraph)
      when /%C2%A9/
        @listener.copyright_line(@paragraph)
        @paragraph = nil
        @states.pop
      else
        nil
      end
    end

    def finish_anchor
      case @link_text
      when /Contact us/
        @listener.contact_us_uri(@href)
      when /About us/
        @listener.about_us_uri(@href)
      else
        nil
      end
      @link_text = nil
      @states.pop
    end

    def end_document
    end

  end

end
