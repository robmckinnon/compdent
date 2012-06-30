# encoding: utf-8
require 'nokogiri'

module Compdent

  module DefaultPageListener
    def self.about_us_uri uri
      # puts "  about us: #{uri}"
    end

    def self.contact_us_uri uri
      # puts "  contact us: #{uri}"
    end

    def self.copyright_organisation_name name
      puts "\n   name: #{name}\n"
    end

    def self.copyright_company_number number
      puts "\n   number: #{number}\n"
    end
  end

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

    def comment text
    end

    def cdata_block text
    end

    def error text
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
      @href = if href
        if href[/^http/]
          href
        elsif href[/google_ads|mailto/]
          nil
        else
          @base_uri.merge(href).to_s rescue URI::InvalidURIError
        end
      else
        nil
      end
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
        finish_paragraph if name == 'p' && @paragraph
      else
        nil
      end
    end

    def finish_paragraph
      begin
        escaped = URI.escape(@paragraph)
        case escaped
        when /%C2%A9/
          copyright_line( URI.unescape(escaped.sub('%C2%A9','&copy;')) )
          @paragraph = nil
          @states.pop
        else
          @paragraph = nil
          nil
        end
      rescue
        nil
      end
    end

    def copyright_line line
      parser = CopyrightParser.new(line)
      @listener.copyright_organisation_name(parser.organisation_name)
      case number = parser.company_number
      when Array
        number.each {|no| @listener.copyright_company_number(no) }
      else
        @listener.copyright_company_number(number)
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
