require File.dirname(__FILE__) + '/../../spec_helper'

include Compdent

describe UriScraper do

  let(:scraper) { UriScraper.sleep_on_timeout = sleep_on_timeout ; UriScraper }

  describe 'setting sleep on timeout' do
    let(:sleep_on_timeout) { 3 }

    it 'should set value correctly' do
      scraper.sleep_on_timeout.should == 3
    end
  end

  describe 'asked to get_response_body with uri' do

    let(:uri) { 'http://example.com/' }
    let(:body) { mock }
    let(:sleep_on_timeout) { 0 }

    context 'when response is success' do
      before { stub_request(:get, uri).to_return(:body => body, :status => 200 ) }

      it 'should return response body' do
        scraper.get_response_body(uri).should == body
      end
    end

    context 'when response is redirect' do

      it 'should call get_response_body with response.location' do
        location = 'http://example.com/alt'
        stub_request(:get, uri).to_return(:headers => { 'Location' => location }, :status => 301)

        stub_request(:get, location).to_return(:body => body, :status => 200)

        scraper.get_response_body(uri).should == body
      end
    end

    context 'when response is not found' do
      before { stub_request(:get, uri).to_return(:status => 404) }

      it 'should return nil' do
        scraper.get_response_body(uri).should be_nil
      end
    end

    context 'when response is any other status' do
      before { stub_request(:get, uri).to_return(:status => 500) }

      it 'should return nil' do
        scraper.get_response_body(uri).should be_nil
      end
    end

    context 'when timeout error is raised' do
      context 'then requests succeeds' do
        before do
          stub_request(:get, uri).to_timeout.then.to_return(:body => body, :status => 200)
        end

        it 'should return response body' do
          scraper.get_response_body(uri).should == body
        end
      end

      context 'and then timeout error is raised again' do
        before do
          stub_request(:get, uri).to_timeout.then.to_timeout.then.to_return(:body => body, :status => 200)
        end

        it 'should return nil' do
          scraper.get_response_body(uri).should be_nil
        end
      end
    end
  end

end
