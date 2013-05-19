require 'test_helper'

describe Lyricfy::Wikia do
  describe "with valid params" do
    it "should format parameters with semicolon" do
      provider = Lyricfy::Wikia.new artist_name: 'Coldplay', song_name: 'Fix You'
      provider.send(:format_parameters).must_equal "Coldplay:Fix_You"
    end
  end

  describe "#search" do
    describe "404" do
      before :each do
        provider = Lyricfy::Wikia.new artist_name: '2pac', song_name: 'kfjawl'
        VCR.use_cassette('wikia_404') { @result = provider.search }
      end

      it "should return nil" do
        @result.must_be_nil
      end
    end

    describe "200" do
      before do
        provider = Lyricfy::Wikia.new artist_name: '2pac', song_name: 'life goes on'
        VCR.use_cassette('wikia_200') { @result = provider.search }
      end

      it "should return an Array" do
        @result.must_be_instance_of Array
      end

      it "should remove all html tags" do
        @result.join(" ").wont_match(/\<*\>/)
      end
    end
  end
end
