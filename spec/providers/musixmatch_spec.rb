require 'spec_helper'

describe Lyricfy::Musixmatch do
  describe "with valid params" do
    it "should format parameters with semicolon" do
      provider = Lyricfy::Musixmatch.new artist_name: 'Coldplay', song_name: 'Fix You'

      provider.send(:format_parameters).must_equal "coldplay/fix-you"
    end
  end
end
