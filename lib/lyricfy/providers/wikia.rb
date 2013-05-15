# coding: utf-8

module Lyricfy
  class Wikia < Lyricfy::LyricProvider
    include URIHelper

    def initialize(parameters)
      super(parameters)
      self.base_url = "http://lyrics.wikia.com/"
      self.url = URI.escape(self.base_url + format_parameters)
    end

    def search
      begin
        html = Nokogiri::HTML(open(url))
        lyricbox = html.css('div.lyricbox').first

        # Removing ads
        if ads = lyricbox.css('.rtMatcher')
          ads.each do |matcher|
            matcher.remove
          end
        end

        instrumental = lyricbox.search("[title=Instrumental]").first

        edit_meta = lyricbox.search("a[title='LyricWiki:Job Exchange']")
        edit_meta.remove if edit_meta

        if instrumental
          ""
        else
          lyricbox.children.to_html
        end
      rescue OpenURI::HTTPError
        nil
      end
    end

    private
    def format_parameters
      artist_name = tilde_to_vocal(self.parameters[:artist_name])
      song_name = tilde_to_vocal(self.parameters[:song_name])
      "#{artist_name}:#{song_name}"
    end
  end
end