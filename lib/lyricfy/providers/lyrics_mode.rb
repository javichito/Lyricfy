module Lyricfy
  class LyricsMode < Lyricfy::LyricProvider
    include URIHelper

    def initialize(parameters)
      super(parameters)
      self.base_url = "http://m.lyricsmode.com/lyrics/o/"
      self.url = URI.escape(self.base_url + format_parameters)
    end

    def format_parameters
      artist_name = prepare_parameter(self.parameters[:artist_name])
      song_name = prepare_parameter(self.parameters[:song_name])
      "#{artist_name}/#{song_name}.html"
    end

    def prepare_parameter(parameter)
      parameter.downcase.split(' ').map { |w| tilde_to_vocal(w).gsub(/\W/, '') }.join('_')
    end

    def search
      begin
        html = Nokogiri::HTML(open(url))
        lyricbox = html.css('#songlyrics')
        lyricbox.children.to_html
      rescue OpenURI::HTTPError
        nil
      end
    end
  end
end