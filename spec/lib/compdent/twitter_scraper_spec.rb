require File.dirname(__FILE__) + '/../../spec_helper'

include Compdent

describe TwitterScraper do

  let(:screen_name) { 'tweeter' }

  let(:scraper) { TwitterScraper.new(screen_name) }

  context 'tweeter follows other tweeters' do
    before do
      stub_http_request(:get, "api.twitter.com/1/friends/ids.json").
        with(:query => { 'screen_name' => 'tweeter'}).
        to_return :body => '{
          "previous_cursor_str":"0",
          "next_cursor":0,
          "ids":[6253282,783214]
          ,"previous_cursor":0,
          "next_cursor_str":"0"
        }'

      stub_request(:post, "http://api.twitter.com/1/users/lookup.json").
        with(:body => {"user_id"=>"6253282,783214"}).
        to_return :body => '[{
        "name": "Twitter API",
        "url": "http://apiwiki.twitter.com",
        "id": 6253282,
        "screen_name": "twitterapi"
        },
        {
        "name": "Twitter",
        "url": "http://twitter.com",
        "id": 783214,
        "screen_name": "twitter"
        }]'
    end

    after do
      Tweeter.delete_all
    end

    subject { scraper.retrieve }

    its(:screen_name) { should == screen_name }

    its(:following_ids) { should == [6253282,783214] }

  end

  context 'tweeter already exists' do
    before do
      tweeter = Tweeter.new :screen_name => screen_name
      tweeter.save
    end

    subject { scraper.retrieve }

    its(:following_ids) { should be_nil }
  end

end
