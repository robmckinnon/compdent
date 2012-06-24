require File.dirname(__FILE__) + '/../../spec_helper'

include Compdent

describe TwitterScraper do

  let(:screen_name) { 'tweeter' }
  let(:user_id) { 1234 }
  let(:tweeter) { 'mock tweeter' }

  describe 'from_screen_name' do

    it 'should find_or_create_by screen_name' do
      Tweeter.should_receive(:find_or_create_by).with(:screen_name => screen_name).and_return tweeter
      Tweeter.from_screen_name(screen_name).should == tweeter
    end

    it 'should persist tweeter' do # tests mongoid
      tweeter = Tweeter.from_screen_name(screen_name)
      Tweeter.find_by(:screen_name => screen_name).should == tweeter
      Tweeter.delete_all
    end
  end

  describe 'from_user_id' do

    it 'should find_or_create_by user_id' do
      Tweeter.should_receive(:find_or_create_by).with(:user_id => user_id).and_return tweeter
      Tweeter.from_user_id(user_id).should == tweeter
    end

    it 'should persist tweeter' do # tests mongoid
      tweeter = Tweeter.from_user_id(user_id)
      Tweeter.find_by(:user_id => user_id).should == tweeter
      Tweeter.delete_all
    end
  end
end
