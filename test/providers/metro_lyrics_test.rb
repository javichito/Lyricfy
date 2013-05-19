require 'test_helper'

describe Lyricfy::MetroLyrics do
  describe "with valid params" do
    it "should format parameters with hyphen" do
      provider = Lyricfy::MetroLyrics.new artist_name: 'Coldplay', song_name: 'Fix You'
      provider.send(:format_parameters).must_equal "fix-you-lyrics-coldplay"
    end
  end

  describe "#search" do
    describe "404" do
      it "should return nil" do
        provider = Lyricfy::MetroLyrics.new artist_name: '2pac', song_name: 'kfjawl'
        VCR.use_cassette('metro_lyrics_404') do
          result = provider.search
          result.must_be_nil
        end
      end
    end

    describe "200" do
      before do
        provider = Lyricfy::MetroLyrics.new artist_name: '2pac', song_name: 'life goes on'
        VCR.use_cassette('metro_lyrics_200') { @result = provider.search }
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
