require File.dirname(__FILE__) + '/../../spec_helper'

include Compdent

describe WebPage do

  describe "asked for canonical URI" do
    context "for host uri with trailing slash" do
      it 'should return uri unmodified' do
        WebPage.canonical_uri('http://example.com/').should == 'http://example.com/'

      end
    end

    context "for host uri without trailing slash" do
      it 'should return uri with trailing slash' do
        WebPage.canonical_uri('http://example.com?a=b&x=y').should == 'http://example.com/?a=b&x=y'

      end
    end

    context "for uri with path after host" do
      it 'should return uri unmodified' do
        WebPage.canonical_uri('http://example.com/more?a=b&x=y').should == 'http://example.com/more?a=b&x=y'

      end
    end
  end
end
