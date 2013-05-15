# Lyricfy

Song Lyrics for your Ruby apps.

## Installation

Add this line to your application's Gemfile:

    gem 'lyricfy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lyricfy

## Usage

    You need to create an instance of the <code>Lyricfy::Fetcher</code> class and send the #search message with the artist name and song title respectively. The following example shows the most basic usage.

    fetcher = Lyricfy::Fetcher.new
    lyric = fetcher.search 'Coldplay', 'Viva la vida'
    puts lyric.body.join('\n')

    The <code>Lyricfy::Fetcher#search</code> method returns an OpenStruct object with the following methods:

      - artist
      - song
      - body

    Where artist is the artist name, song is the song title and body is an Array of the lyric paragraphs.

### How does it work?

    Under the hood, this library fetch the songs lyrics by scraping some websites called "Providers". The currently supported providers are:

      - (http://lyrics.wikia.com/Lyrics_Wiki)[Wikia]
      - (http://www.metrolyrics.com/)[MetroLyrics]
      - (http://www.lyricsmode.com/)[LyricsMode]
      - (http://kdletras.com/)[KDLetras]

    By default this gem will recursively search for the lyric on each of the providers, if the lyric is not found it will return nil. You can also tell Lyricfy to only use the provider(s) that you want.

    fetcher = Lyricfy::Fetcher.new(:metro_lyrics, :lyrics_mode)
    lyric = fetcher.search 'Coldplay', 'Viva la vida'
    puts lyric.body.join('\n')

    In this case Lyricfy will look for the lyrics first on MetroLyrics and if it is not found it will fallback to LyricsMode.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
