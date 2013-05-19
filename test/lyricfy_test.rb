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
  end
end