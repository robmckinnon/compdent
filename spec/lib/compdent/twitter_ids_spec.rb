require File.dirname(__FILE__) + '/../../spec_helper'

include Compdent

describe TwitterIds do

  let(:first_id) { 6253282 }
  let(:last_id) { 783214 }
  let(:following_ids) { [first_id, last_id] }
  let(:twitter_ids) { TwitterIds.new following_ids }

  describe "asked for new_ids" do
    it 'should return ids that do not exist yet' do

      Tweeter.should_receive(:user_id_exists?).with(first_id).and_return true
      Tweeter.should_receive(:user_id_exists?).with(last_id).and_return false

      twitter_ids.new_ids.should == [last_id]
    end
  end
end
