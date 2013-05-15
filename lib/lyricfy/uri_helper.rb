# coding: utf-8

module Lyricfy
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
end