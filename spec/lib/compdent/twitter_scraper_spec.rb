require File.dirname(__FILE__) + '/../../spec_helper'

include Compdent

describe TwitterScraper do

  let(:user_id) { 123 }
  let(:screen_name) { 'tweeter' }
  let(:create_options) { { :screen_name => screen_name } }
  let(:scraper) { TwitterScraper.new(create_options) }
  let(:twitter) { mock('twitter') }
  let(:following_ids) { [6253282,783214] }

  before do
    Twitter.stub(:new).and_return twitter
  end

  describe "creating from screen_name" do
    it 'should create tweeter' do
      Tweeter.should_receive(:from_screen_name).with(screen_name)
      scraper
    end
  end

  describe "creating from user_id" do
    let(:create_options) { { :user_id => user_id } }

    it 'should create tweeter' do
      Tweeter.should_receive(:from_user_id).with(user_id)
      scraper
    end
  end

  describe "asked to retrieve by screen_name" do

    let(:tweeter) do
      mock('tweeter',
        :screen_name => screen_name,
        :following_ids => following_ids,
        :following_ids_changed? => false)
    end

    before do
      tweeter.stub(:has_following_ids?).and_return(false)
      twitter.stub(:following_ids).and_return following_ids
      Tweeter.stub(:from_screen_name).and_return tweeter
      tweeter.stub(:following_ids=)
    end

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
        tweeter.stub(:has_following_ids?).and_return(false)
        tweeter.stub(:following_ids_changed?).and_return true
        tweeter.stub(:save)
        scraper.stub(:retrieve_following)
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
    let(:user_id) { 783214 }
    let(:data) { mock('tweeter', :name => "Twitter",
      :url => "http://twitter.com",
      :id => user_id,
      :screen_name => "twitter" ) }

    let(:tweeter) { mock('tweeter') }

    before do
      twitter.stub(:each_lookup).and_yield data
    end

    it 'should update data on Tweeter' do
      Tweeter.should_receive(:from_user_id).with(user_id).and_return tweeter
      tweeter.should_receive(:update_data).with(data)
      scraper.retrieve_following following_ids
    end
  end


end
