module Lyricfy
  class MetroLyrics < Lyricfy::LyricProvider
    include URIHelper

    def initialize(parameters)
      super(parameters)
      self.base_url = "http://m.metrolyrics.com/"
      self.url = URI.escape(self.base_url + format_parameters)
    end

    def format_parameters
      artist_name = prepare_parameter(self.parameters[:artist_name])
      song_name = prepare_parameter(self.parameters[:song_name])
      "#{song_name}-lyrics-#{artist_name}"
    end

    def prepare_parameter(parameter)
      parameter.downcase.split(' ').map { |w| w.gsub(/\W/, '') }.join('-')
    end

    def search
      begin
        html = Nokogiri::HTML(open(url))
        lyricbox = html.css('p.lyricsbody').first

        # Removing ads
        if ads = lyricbox.css('.lyrics-ringtone')
          ads.each do |matcher|
            matcher.remove
          end
        end

        if credits = lyricbox.css('span')
          credits.each do |span|
            span.remove
          end
        end

        lyricbox.children.to_html
      rescue OpenURI::HTTPError
        nil
      end
    end
  end
end