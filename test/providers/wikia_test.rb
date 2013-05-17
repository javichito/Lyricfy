require 'test_helper'

describe Lyricfy::Wikia do
  describe "with valid params" do
    it "should format parameters with semicolon" do
      provider = Lyricfy::Wikia.new artist_name: 'Coldplay', song_name: 'Fix You'
      provider.send(:format_parameters).must_equal "Coldplay:Fix You"
    end
  end

  describe "#search" do
    describe "404" do
      before :each do
        VCR.use_cassette('wikia_404') do
          @response = Net::HTTP.get_response(URI('http://lyrics.wikia.com/2pac:life'))
          @provider = Lyricfy::Wikia.new artist_name: '2pac', song_name: 'life'
        end
      end

      it "should return HTTP code 404" do
        "404".must_equal @response.code
      end

      it "should return nil" do
        VCR.use_cassette('wikia_404') do
          @provider.search.must_be_nil
        end
      end
    end

    describe "200" do
      before do
        VCR.use_cassette('wikia_200') do
          @response = Net::HTTP.get_response(URI('http://lyrics.wikia.com/2pac:life_goes_on'))
          @provider = Lyricfy::Wikia.new artist_name: '2pac', song_name: 'life_goes_on'
        end
      end

      it "should return HTTP code 200" do
        "200".must_equal @response.code
      end

      it "should remove the ads" do
        VCR.use_cassette('wikia_200') do
          @provider.search.wont_match /rtMatcher/
        end
      end

      it "should remove edit meta" do
        VCR.use_cassette('wikia_200') do
          @provider.search.wont_match "a[title='LyricWiki:Job Exchange']"
        end
      end

      it "should return nil when instrumental is found"
      it "should return an Array"
    end
  end
end
