require File.dirname(__FILE__) + '/../../spec_helper'

include Compdent

describe TwitterScraper do

  let(:screen_name) { 'tweeter' }

  let(:scraper) { TwitterScraper.new(screen_name) }
  let(:twitter) { mock('twitter') }

  context 'tweeter follows other tweeters' do

    let(:following_ids) { [6253282,783214] }
    let(:tweeter) { mock('tweeter', :following_ids => following_ids, :following_ids_changed? => false) }

    before do
      Twitter.stub(:new).and_return twitter
      twitter.stub(:following_ids).and_return following_ids
      Tweeter.stub(:from_screen_name).and_return tweeter
      tweeter.stub(:following_ids=)
    end

    describe "asked to retrieve by screen_name" do

      context 'following_ids are same' do
        it 'should not retrieve_following' do
          scraper.should_not_receive(:retrieve_following)
          scraper.retrieve
        end
        it 'should not save tweeter' do
          tweeter.should_not_receive(:save)
          scraper.retrieve
        end
      end

      context 'following_ids are new' do
        before do
          tweeter.stub(:following_ids_changed?).and_return true
          tweeter.stub(:save)
        end

        it 'should set following_ids and save' do
          tweeter.should_receive(:following_ids=).with(following_ids)
          tweeter.should_receive(:save)
          scraper.retrieve
        end

        it 'should call retrieve_following' do
          scraper.should_receive(:retrieve_following).with(following_ids)
          scraper.retrieve
        end
      end

    end

    describe "asked to retrieve_following" do
      it 'should call Twitter each lookup with following_ids' do
        twitter.should_receive(:each_lookup).with(following_ids).and_yield mock('tweeter')
        scraper.retrieve_following following_ids
      end
    end

  end

      let(:tweeter) { mock('tweeter', :name => "Twitter",
        :url => "http://twitter.com",
        :id => 783214,
        :screen_name => "twitter" ) }

      before do
      twitter.stub(:each_lookup).and_yield mock('tweeter')
      end
end
