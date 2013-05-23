# Lyricfy

Song Lyrics for your Ruby apps.

[![Build Status](https://travis-ci.org/javichito/Lyricfy.png?branch=master)](https://travis-ci.org/javichito/Lyricfy)
[![Code Climate](https://codeclimate.com/github/javichito/Lyricfy.png)](https://codeclimate.com/github/javichito/Lyricfy)

## Installation

Add this line to your application's Gemfile:

    gem 'lyricfy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lyricfy

## Usage

You need to create an instance of the <code>Lyricfy::Fetcher</code> class and send the <code>#search</code> message with the artist name and song title respectively. The following example shows the most basic usage.

    fetcher = Lyricfy::Fetcher.new
    lyric = fetcher.search 'Coldplay', 'Viva la vida'
    puts lyric.body # prints lyrics, one line at a time
    lyric.body.each { |line| puts "#{line}<br/>" } # Iterate over each line

The <code>Lyricfy::Fetcher#search</code> method returns an OpenStruct object with the following methods:

- artist
- song
- body

Where artist is the artist name, song is the song title and body is an Array of the lyric paragraphs.

### How does it work?

Under the hood, this library fetch the songs lyrics by scraping some websites called "Providers". The currently supported providers are:

- [Wikia](http://lyrics.wikia.com/Lyrics_Wiki)
- [MetroLyrics](http://www.metrolyrics.com/)

By default this gem will recursively search for the lyric on each of the providers, if the lyric is not found it will return nil. You can also tell Lyricfy to only use the provider(s) that you want.

    fetcher = Lyricfy::Fetcher.new(:metro_lyrics)
    lyric = fetcher.search 'Coldplay', 'Viva la vida'
    lyric.body.each { |line| puts line }

In this case Lyricfy will look for the lyric only on [MetroLyrics](http://www.metrolyrics.com/).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
