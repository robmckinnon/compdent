# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../../lib/compdent/page_parser'

describe Compdent::PageParser do

  let(:listener) { mock('listener') }
  let(:base_uri) { 'http://example.com/' }
  let(:uri) { "#{base_uri}#{uri_path}/" }

  let(:parser) { Compdent::PageParser.new(listener) }

  def do_parse
    parser.parse(html, base_uri)
  end
=begin
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

  context 'About Us link in page' do
    let(:html) { "<a href='#{uri}'>About us</a>" }
    let(:uri_path) { 'about-us' }

    it 'should callback contact_us_uri' do
      listener.should_receive(:about_us_uri).with(uri)
      do_parse
    end
  end
=end
  shared_examples 'copywrite lines' do
    before do
      listener.stub(:copyright_company_number)
      listener.stub(:copyright_organisation_name)
    end

    it 'should callback copyright_line' do
      parser.should_receive(:copyright_line).with( line.sub('–','-') )
      do_parse
    end

    it 'should callback copyright_company_number' do
      listener.should_receive(:copyright_company_number).with('0123456')
      do_parse
    end

    it 'should callback copyright_organisation_name' do
      listener.should_receive(:copyright_organisation_name).with('Acme Ltd')
      do_parse
    end

    context "with two company numbers" do
      let(:line) { '&copy; registered in England and Wales with company registration numbers 04252091 & 04252093' }
      it 'should callback copyright_company_number twice' do
        listener.should_receive(:copyright_company_number).with('04252091').with('04252093').ordered
        do_parse
      end
    end
  end

  context 'copywrite line' do
    let(:line) { 'Copyright &copy; Acme Ltd 2007. All rights reserved – Registered in England No 0123456' }

    context 'in paragraph' do
      let(:html) { %Q|<p class="floatl">#{line}</p>| }

      include_examples 'copywrite lines'
    end

    context 'in div' do
      let(:html) { %Q|<div class="floatl">#{line}</div>| }

      include_examples 'copywrite lines'
    end
  end

end
