module Lyricfy
  class LyricProvider
    attr_accessor :base_url, :url, :parameters

    def initialize(parameters = {})
      self.parameters = parameters
    end

    def search
      begin
        data = open(self.url)
      rescue OpenURI::HTTPError
        nil
      end
    end
  end
end