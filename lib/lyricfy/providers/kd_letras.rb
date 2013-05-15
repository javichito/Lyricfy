module Lyricfy
  class KDLetras < Lyricfy::LyricProvider
    def initialize(parameters)
      super(parameters)
      self.base_url = "http://kdletras.com/"
      self.url = URI.escape(self.base_url + format_parameters)
    end

    def format_parameters
      artist_name = prepare_parameter(self.parameters[:artist_name])
      song_name = prepare_parameter(self.parameters[:song_name])
      "#{artist_name}/#{song_name}"
    end

    def search
      begin
        html = Nokogiri::HTML(open(url))
        lyricbox = html.css('#lyr_original')

        lyricbox.css('a').each do |link|
          link.attributes["href"].value = "javascript:void(0)"
        end

        lyricbox.children.to_html
      rescue OpenURI::HTTPError
        nil
      end
    end

    def prepare_parameter(parameter)
      parameter.split(' ').map { |w| w.gsub(/\W/, '') }.join('-')
    end
  end
end