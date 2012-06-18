require File.dirname(__FILE__) + '/../../spec_helper'

describe Compdent::TwitterScraper do

  let(:screen_name) { 'tweeter' }

  let(:scraper) { Compdent::TwitterScraper.new(screen_name) }

  context 'tweeter follows other tweeters' do
    before do
      stub_http_request(:get, "api.twitter.com/1/friends/ids.json").
        with(:query => { 'screen_name' => 'tweeter'}).
        to_return :body => '{
          "previous_cursor_str":"0",
          "next_cursor":0,
          "ids":[144951864,564399073,561022558]
          ,"previous_cursor":0,
          "next_cursor_str":"0"
        }'
    end

    subject { scraper.retrieve }

    its(:screen_name) { should == screen_name }

    its(:following_ids) { should == [144951864,564399073,561022558] }

  end

  context 'tweeter already exists' do
    before do
      tweeter = Compdent::Tweeter.new :screen_name => screen_name
      Compdent::TweeterRepository.save(tweeter)
    end

    subject { scraper.retrieve }

    its(:following_ids) { should be_nil }
  end

end
