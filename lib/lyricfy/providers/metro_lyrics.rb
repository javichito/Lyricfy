module Lyricfy
  class MetroLyrics < Lyricfy::LyricProvider
    include URIHelper

    def initialize(parameters)
      super(parameters)
      self.base_url = "http://www.metrolyrics.com/"
      self.url = URI.escape(self.base_url + format_parameters)
    end

    def search
      if data =  super
        html = Nokogiri::HTML(data)
        html_to_array(html)
      end
    end

    private

    def prepare_parameter(parameter)
      parameter.downcase.split(' ').map { |w| w.gsub(/\W/, '') }.join('-')
    end

    def format_parameters
      artist_name = prepare_parameter(self.parameters[:artist_name])
      song_name = prepare_parameter(self.parameters[:song_name])
      "#{song_name}-lyrics-#{artist_name}.html"
    end

    def html_to_array(html)
      container = html.css('#lyrics-body-text').first || html.css('p.gnlyricsbody').first

      if container
        textNodes = []
        paragraphs = container.css('.verse')

        paragraphs.each do |p|
          p.children.each do |ele|
            if ele.text?
              text = ele.text.strip.chomp
              textNodes.push(text) unless text.empty?
            end
          end
        end

        textNodes
      end
    end
  end
end