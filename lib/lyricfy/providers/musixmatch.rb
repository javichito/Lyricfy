module Lyricfy
  class Musixmatch < Lyricfy::LyricProvider
    include URIHelper

    def initialize(parameters)
      super(parameters)
      self.base_url = "https://www.musixmatch.com/"
      self.url = URI.escape(self.base_url + format_parameters)
    end

    def search
      html = Nokogiri::HTML(open(self.url ).read)
      html.encoding = 'utf-8'
      html_to_array(html)
    end

    private

    def prepare_parameter(parameter)
      parameter.downcase.split(' ').join('-')
    end

    def format_parameters
      artist_name = prepare_parameter(self.parameters[:artist_name])
      song_name = prepare_parameter(self.parameters[:song_name])
      "lyrics/#{artist_name}/#{song_name}"
    end

    def html_to_array(html)
      containers = html.css('.mxm-lyrics__content')
      if containers.any?
        result = []
        container.each do |container|
          elements = container.children.text.split("\n").reject{|e| e.empty?}
          result += elements if elements.any?
        end
        result
      end
    end
  end
end