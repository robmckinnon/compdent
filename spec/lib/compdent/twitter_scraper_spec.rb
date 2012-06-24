require File.dirname(__FILE__) + '/../../spec_helper'

include Compdent

describe TwitterScraper do

  let(:screen_name) { 'tweeter' }

  let(:scraper) { TwitterScraper.new(screen_name) }

  context 'tweeter follows other tweeters' do

    let(:following_ids) { [6253282,783214] }
    let(:twitter) { mock('twitter') }
    let(:tweeter) { mock('tweeter', :name => "Twitter",
        :url => "http://twitter.com",
        :id => 783214,
        :screen_name => "twitter" ) }

    before do
      Twitter.stub(:new).and_return twitter
      twitter.stub(:following_ids).and_return following_ids
      twitter.stub(:each_lookup).and_yield tweeter
    end

    after do
      Tweeter.delete_all
    end

    describe "asked to retrieve by screen_name" do
      it 'should find following_ids' do
        twitter.should_receive(:following_ids).with(screen_name).and_return following_ids
        scraper.retrieve
      end

      it 'should call Twitter each lookup with following_ids' do
        twitter.should_receive(:each_lookup).with(following_ids).and_yield mock('tweeter')
        scraper.retrieve
      end

      it 'should create Tweeter from lookup data' do

      end
    end

  end

end
