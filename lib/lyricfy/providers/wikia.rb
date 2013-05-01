# coding: utf-8
require 'open-uri'

class Letra
  attr_accessor :letra

  def self.search(artist_name, song_name)
    provider1 = Lyrical::Wikia.new(artist_name: artist_name, song_name: song_name)
    provider2 = Lyrical::MetroLyrics.new(artist_name: artist_name, song_name: song_name)
    provider3 = Lyrical::KDLetras.new(artist_name: artist_name, song_name: song_name)
    provider4 = Lyrical::LyricsMode.new(artist_name: artist_name, song_name: song_name)
    provider5 = Lyrical::SonicoMusica.new(artist_name: artist_name, song_name: song_name)

    letra = Letra.new
    letra.letra = provider1.search || provider2.search
    (letra.letra = provider3.search) if letra.letra.nil?
    (letra.letra = provider4.search) if letra.letra.nil?
    (letra.letra = provider5.search) if letra.letra.nil?
    letra
  end
end


module Lyrical
  module URIHelper
    def tilde_to_vocal(string)
      string.split('').map do |c|
        case c
            when "á" then "a"
            when "é" then "e"
            when "í" then "i"
            when "ó" then "o"
            when "ú" then "u"
            else c
        end
      end.join('')
    end
  end

  class LyricProvider
    attr_accessor :base_url, :url, :parameters

    def initialize(parameters = {})
      self.parameters = parameters
    end
  end

  class Wikia < LyricProvider
    include URIHelper

    def initialize(parameters)
      super(parameters)
      self.base_url = "http://lyrics.wikia.com/"
      self.url = URI.escape(self.base_url + format_parameters)
    end

    def format_parameters
      artist_name = tilde_to_vocal(self.parameters[:artist_name])
      song_name = tilde_to_vocal(self.parameters[:song_name])
      "#{artist_name}:#{song_name}"
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
  end

  class MetroLyrics < LyricProvider
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

  class KDLetras < LyricProvider
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

  class LyricsMode < LyricProvider
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

  class SonicoMusica < LyricProvider
    include URIHelper

    def initialize(parameters)
      super(parameters)
      self.base_url = "http://www.sonicomusica.com/cumbias/"
      self.url = URI.escape(self.base_url + format_parameters)
    end

    def format_parameters
      artist_name = prepare_parameter(self.parameters[:artist_name])
      song_name = prepare_parameter(self.parameters[:song_name])
      "#{artist_name}/cancion/#{song_name}/"
    end

    def prepare_parameter(parameter)
      parameter.downcase.split(' ').map { |w| tilde_to_vocal(w).gsub(/\W/, '') }.join('-')
    end

    def search
      begin
        html = Nokogiri::HTML(open(url))
        lyricbox = html.css('#list-player > pre').first
        if lyricbox
          lyricbox.to_html.chomp
        else
          ""
        end
      rescue OpenURI::HTTPError
        nil
      end
    end
  end
end