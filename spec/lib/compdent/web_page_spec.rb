require File.dirname(__FILE__) + '/../../spec_helper'

include Compdent

describe WebPage do

  describe "asked for canonical URI" do
    context "for host uri with trailing slash" do
      it 'should return uri unmodified' do
        WebPage.canonical_uri('http://example.com/?a=b&x=y').
          should == 'http://example.com/?a=b&x=y'
      end
    end

    context "for host uri without trailing slash" do
      it 'should return uri with trailing slash' do
        WebPage.canonical_uri('http://example.com?a=b&x=y').
          should == 'http://example.com/?a=b&x=y'
      end
    end

    context "for uri with path after host" do
      it 'should return uri unmodified' do
        WebPage.canonical_uri('http://example.com/more?a=b&x=y').
          should == 'http://example.com/more?a=b&x=y'
      end
    end
  end

  describe 'from_uri' do
    let(:uri) { 'http://example.com'}
    let(:web_page) { mock('web_page', :content => nil) }
    let(:page_content) { nil }

    before do
      stub_request(:get, "http://example.com/").to_return :body => page_content
    end

    it 'should find_or_create_by uri' do
      WebPage.should_receive(:find_or_create_by).with(:uri => "#{uri}/").and_return web_page
      WebPage.from_uri(uri).should == web_page
    end

    it 'should persist web_page' do # tests mongoid
      page = WebPage.from_uri(uri)
      WebPage.find_by(:uri => WebPage.canonical_uri(uri)).should == page
      WebPage.delete_all
    end

    context "and http request returns content" do
      let(:page_content) { 'body' }

      it 'should persist content' do # tests mongoid
        WebPage.from_uri(uri)
        WebPage.find_by(:uri => WebPage.canonical_uri(uri)).content.should == page_content
        WebPage.delete_all
      end
    end

  end

end
