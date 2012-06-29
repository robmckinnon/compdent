require File.dirname(__FILE__) + '/../../spec_helper'

include Compdent

describe Compdent::PageParser do

  let(:listener) { mock('listener') }
  let(:base_uri) { 'http://example.com/' }
  let(:uri) { "#{base_uri}#{uri_path}/" }

  let(:parser) { Compdent::PageParser.new(listener) }

  def do_parse
    parser.parse(html, base_uri)
  end

  context 'Contact Us link in page' do
    let(:html) { "<a href='#{uri}'>Contact us</a>" }
    let(:uri_path) { 'contact-us' }

    it 'should callback contact_us_uri' do
      listener.should_receive(:contact_us_uri).with(uri)
      do_parse
    end

    context 'and link is relative' do
      let(:html) { "<a href='/#{uri_path}/'>Contact us</a>" }

      it 'should callback contact_us_uri' do
        listener.should_receive(:contact_us_uri).with(uri)
        do_parse
      end
    end
  end

  context 'Contact Us link in page' do
    let(:html) { "<a href='#{uri}'>About us</a>" }
    let(:uri_path) { 'about-us' }

    it 'should callback contact_us_uri' do
      listener.should_receive(:about_us_uri).with(uri)
      do_parse
    end
  end

end
