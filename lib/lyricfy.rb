require 'ostruct'
require "open-uri"
require "nokogiri"
require_relative "lyricfy/version"
require_relative "lyricfy/uri_helper"
require_relative "lyricfy/song"
require_relative "lyricfy/lyric_provider"
require_relative "lyricfy/providers/wikia"
require_relative "lyricfy/providers/metro_lyrics"

module Lyricfy
  class Fetcher
    attr_reader :providers

    def initialize(*args)
      @providers = {
        wikia: Wikia,
        metro_lyrics: MetroLyrics
      }

      unless args.empty?
        passed_providers = {}
        args.each do |provider|
          raise Exception unless @providers.has_key?(provider)
          passed_providers[provider] = @providers[provider]
        end
        @providers = passed_providers
      end
    end

    def search(artist, song)
      key = [artist.downcase, song.downcase]
      @cached_search ||= {}

      @cached_search.fetch(key) do
        result = nil
        @providers.each_pair do |provider, klass|
          fetcher = klass.new(artist_name: artist, song_name: song)

          if lyric_body = fetcher.search
            result =  Lyricfy::Song.new(song, artist, lyric_body)
            break
          end
        end
        @cached_search[key] = result
      end
    end
  end
end
