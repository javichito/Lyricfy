module Lyricfy
  class MetroLyrics < Lyricfy::LyricProvider
    include URIHelper

    def initialize(parameters)
      super(parameters)
      self.base_url = "http://m.metrolyrics.com/"
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
      "#{song_name}-lyrics-#{artist_name}"
    end

    def html_to_array(html)
      container = html.css('p.lyricsbody').first || html.css('p.gnlyricsbody').first
      elements = container.children.to_a
      paragraphs = elements.select { |ele| ele.text? }
      paragraphs.map! { |paragraph| paragraph.text.strip.chomp if paragraph.text != "\n" }.reject! { |ele| ele.empty? }
    end
  end
end