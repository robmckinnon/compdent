require File.dirname(__FILE__) + '/../../spec_helper'

include Compdent

describe Twitter do

  let(:screen_name) { 'tweeter' }

  let(:twitter) { Twitter.new }

  context 'tweeter follows other tweeters' do

    let(:first_id) { 6253282 }
    let(:first_name) { 'Twitter API' }
    let(:first_url) { 'http://apiwiki.twitter.com' }
    let(:first_screen_name) { 'twitterapi' }
    let(:following_ids) { [first_id, 783214] }

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
        to_return :body => %Q|[{
        "name": "#{first_name}",
        "url": "#{first_url}",
        "id": #{first_id},
        "screen_name": "#{first_screen_name}"
        },
        {
        "name": "Twitter",
        "url": "http://twitter.com",
        "id": 783214,
        "screen_name": "twitter"
        }]|
    end

    describe "asked for following_ids given screen_name" do
      it 'should return following ids' do
        twitter.following_ids(screen_name).should == following_ids
      end
    end

    describe "each_lookup" do
      let(:data1) { mock('item') }
      let(:data2) { mock('item2') }

      before { twitter.stub(:users_lookup).and_return [data1, data2] }

      specify { expect { |b| twitter.each_lookup(following_ids, &b) }.to yield_successive_args(data1, data2) }
    end

    describe "users_lookup" do
      subject { twitter.users_lookup(following_ids).first }

      its(:id) { should == first_id }
      its(:name) { should == first_name }
      its(:url) { should == first_url }
      its(:screen_name) { should == first_screen_name }
    end

  end

end