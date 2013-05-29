require 'test_helper'

describe Lyricfy::Fetcher do
  before do
    @fetcher = Lyricfy::Fetcher.new
  end

  describe "with no params" do
    it "should use default providers" do
      @fetcher.providers.must_include :wikia
      @fetcher.providers.must_include :metro_lyrics
    end
  end

  describe "with invalid params" do
    it "should raise an Exception" do
      lambda { Lyricfy::Fetcher.new("auaa", 123, [[]]) }.must_raise Exception
    end
  end

  describe "with valid params" do
    it "should use passed providers" do
      fetcher = Lyricfy::Fetcher.new :metro_lyrics
      fetcher.providers.shift[0].must_equal :metro_lyrics
    end
  end

  describe "#search" do
    describe "with invalid params" do
      it "should raise ArgumentError" do
        lambda { @fetcher.search }.must_raise ArgumentError
      end
    end

    describe "with valid params" do
      describe "lyric not found" do
        it "should return nil" do
          fetcher = Lyricfy::Fetcher.new :metro_lyrics
          VCR.use_cassette('metro_lyrics_404') do
            result = fetcher.search('2pac', 'kfjawl')
            result.must_be_nil
          end
        end
      end

      describe "lyric found" do
        it "should return lyrics" do
          fetcher = Lyricfy::Fetcher.new :metro_lyrics
          VCR.use_cassette('metro_lyrics_200') do
            result = fetcher.search('2pac', 'Life Goes On')
            result.lines.must_be_instance_of Array
            result.body.must_include 'Life as a baller'
          end
        end
      end
    end
  end
end
