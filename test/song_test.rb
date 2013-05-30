require 'test_helper'

describe Lyricfy::Song do
  before do
    @song = Lyricfy::Song.new 'Yellow', 'Coldplay', ['Look at the stars', 'Look how they shine for you']
  end

  [
    :title,
    :author,
    :lines
  ].each do |param|
    it "should respond to #{param}" do
      @song.must_respond_to param
    end
  end

  describe "#body" do
    describe "with param" do
      it "should use injected separator" do
        @song.body("<br>").must_equal "Look at the stars<br>Look how they shine for you"
      end
    end

    describe "with no params" do
      it "should use default separator" do
        @song.body.must_equal "Look at the stars\\nLook how they shine for you"
      end
    end
  end
end