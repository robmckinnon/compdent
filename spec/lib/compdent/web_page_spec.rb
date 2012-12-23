require File.dirname(__FILE__) + '/../../spec_helper'

include Compdent

describe WebPage do

  describe "asked for canonical URI" do
    context "for host uri with trailing slash and query" do
      it 'should return uri unmodified' do
        uri = WebPage::Uri.new('http://example.com/?a=b&x=y')
        uri.canonical.should == 'http://example.com/?a=b&x=y'
        uri.host_uri?.should be_false
      end
    end

    context "for host uri with trailing slash and no query" do
      it 'should return uri unmodified' do
        uri = WebPage::Uri.new('http://example.com/')
        uri.canonical.should == 'http://example.com/'
        uri.host_uri?.should be_true
      end
    end

    context "for host uri without trailing slash and query" do
      it 'should return uri with trailing slash' do
        uri = WebPage::Uri.new('http://example.com?a=b&x=y')
        uri.canonical.should == 'http://example.com/?a=b&x=y'
        uri.host_uri?.should be_false
      end
    end

    context "for host uri without trailing slash and no query" do
      it 'should return uri with trailing slash' do
        uri = WebPage::Uri.new('http://example.com')
        uri.canonical.should == 'http://example.com/'
        uri.host_uri?.should be_true
      end
    end

    context "for uri with path after host" do
      it 'should return uri unmodified' do
        uri = WebPage::Uri.new('http://example.com/more?a=b&x=y')
        uri.canonical.should == 'http://example.com/more?a=b&x=y'
        uri.host_uri?.should be_false
      end
    end
  end

  describe 'from_uri' do
    let(:uri) { 'http://example.com'}

    it 'should find_or_create_by uri' do
      stub_request(:get, "example.com").to_return :body => 'body'
      web_page = WebPage.new
      web_page.uri = WebPage.canonical_uri(uri)
      WebPage.should_receive(:find_or_create_by).with(:uri => "#{uri}/").and_return web_page
      WebPage.from_uri(uri).should == web_page
    end

    it 'should persist web_page' do # tests mongoid
      stub_request(:get, "example.com").to_return :body => 'body'
      page = WebPage.from_uri(uri)
      WebPage.find_by(:uri => WebPage.canonical_uri(uri)).should == page
      WebPage.delete_all
    end

    context "and http request returns content" do

      it 'should persist content' do # tests mongoid
        stub_request(:get, "example.com").to_return :body => 'body'
        WebPage.from_uri(uri)
        WebPage.find_by(:uri => WebPage.canonical_uri(uri)).content.should == 'body'
        WebPage.delete_all
      end
    end

  end

end
