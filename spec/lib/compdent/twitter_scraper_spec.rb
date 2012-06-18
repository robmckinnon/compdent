require File.dirname(__FILE__) + '/../../spec_helper'

describe TwitterScraper do

  let(:screen_name) { 'tweeter' }

  subject { TwitterScraper.new(screen_name) }

  its(:screen_name) { should == screen_name }

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

    its(:following_ids) { should == [144951864,564399073,561022558] }
  end
end
