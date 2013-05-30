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
    song = fetcher.search 'Coldplay', 'Viva la vida'
    puts song.body # prints lyrics separated by '\n'

You can also pass a custom separator to the <code>#body</code> method. For example:

    lyrics.body("<br>") # returns a String with the song lyrics separated by a <br> tag

The <code>Lyricfy::Fetcher#search</code> method returns a <code>Lyricfy::Song</code> object with the following methods:

- title
- author
- lines
- body

Where title is the song title, author is the song artist, lines is an Array of the lyric paragraphs and body returns a String with the song lyrics separated with <code>\n</code> by default.

### How does it work?

Under the hood, this library fetch the song lyrics by scraping some websites called "Providers". The currently supported providers are:

- [Wikia](http://lyrics.wikia.com/Lyrics_Wiki)
- [MetroLyrics](http://www.metrolyrics.com/)

By default this gem will recursively search for the lyric on each of the providers, if the lyric is not found it will return nil. You can also tell Lyricfy to only use the provider(s) that you want.

    fetcher = Lyricfy::Fetcher.new(:metro_lyrics)
    lyric = fetcher.search 'Coldplay', 'Viva la vida'
    puts lyric.body

In this case Lyricfy will look for the lyric only on [MetroLyrics](http://www.metrolyrics.com/).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
