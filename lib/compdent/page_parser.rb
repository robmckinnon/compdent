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

    COPYRIGHT_SYMBOL = /%C2%A9/
    DASH = /%E2%80%93/

    def initialize listener
      @listener = listener
    end

    def parse html, base_uri
      @base_uri = URI(base_uri)
      html.gsub!('&nbsp;',' ')
      @doc = Nokogiri.HTML(html)
      handle_content
    end

    def handle_content
      handle_paragraphs
      handle_divs
      # handle_anchors
    end

    def handle_paragraphs
      @doc.search('p').each do |para|
        @text = para.inner_text
        handle_text
      end
    end

    def handle_divs
      @doc.search('div').each do |div|
        unless div.inner_html[/<(p|div)/]
          @text = div.inner_text
          handle_text
        end
      end
    end

    def handle_anchors
      @doc.search('a').each do |anchor|
        @link_text = anchor.inner_text
        @href = @base_uri.merge(anchor['href']).to_s
        finish_anchor
      end
    end

    def handle_text
      @escaped = URI.escape(@text)

      if @escaped[COPYRIGHT_SYMBOL]
        @escaped.sub!(COPYRIGHT_SYMBOL,'&copy;')
        @escaped.sub!(DASH,'-')
        copyright_line( URI.unescape(@escaped) )
      end
    end

    def copyright_line line
      parser = CopyrightParser.new(line)
      @listener.copyright_organisation_name(parser.organisation_name)
      number = parser.company_number
      number = [number] unless number.is_a?(Array)

      number.each {|no| @listener.copyright_company_number(no) }
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
    end

  end

end
