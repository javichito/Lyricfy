require 'ostruct'
require "open-uri"
require "nokogiri"
require_relative "lyricfy/version"
require_relative "lyricfy/uri_helper"
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

      if !args.empty?
        passed_providers = {}
        args.each do |provider|
          raise Exception if !@providers.has_key?(provider)
          passed_providers[provider] = @providers[provider]
        end
        @providers = passed_providers
      end
    end

    def search(artist, song)
      result = nil
      @providers.each_pair do |provider, klass|
        fetcher = klass.new(artist_name: artist, song_name: song)

        if lyric_body = fetcher.search
          result =  OpenStruct.new(artist: artist, song: song, body: lyric_body)
        end
      end
      result
    end
  end
end
