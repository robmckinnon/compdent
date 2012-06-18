require File.dirname(__FILE__) + '/../spec_helper'

describe Compdent do
  describe 'initialize' do
    it 'should configure Curator repository' do
      Curator.data_store.should be_a(Curator::Memory::DataStore)
    end
  end
end
