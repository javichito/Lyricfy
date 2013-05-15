module Lyricfy
  class LyricProvider
    attr_accessor :base_url, :url, :parameters

    def initialize(parameters = {})
      self.parameters = parameters
    end
  end
end