module Lyricfy
  class Musixmatch < Lyricfy::LyricProvider
    include URIHelper

    def initialize(parameters)
      super(parameters)
      self.base_url = "https://www.musixmatch.com/"
      self.url = URI.escape(self.base_url + format_parameters)
    end

    def search
      if data = super
        html = Nokogiri::HTML(data)
        html_to_array(html)
      end
    end

    private

    def format_parameters
      artist_name = tilde_to_vocal(self.parameters[:artist_name]).gsub(" ", "-")
      song_name = tilde_to_vocal(self.parameters[:song_name]).gsub(" ", "-")
      "#{artist_name}/{song_name}"
    end

    def html_to_array(html)
      containers = html.css('.mxm-lyrics__content')
      if containers.any?
        result = []
        container.each do |container|
          elements = container.children.text.split("\n")
          result << elements if elements.any?
        end
        result
      end
    end
  end
end