require(File.expand_path('../../lib/lyricfy', __FILE__))

require 'minitest/autorun'
require 'minitest/pride'
require 'webmock'
require 'webmock/minitest'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
end
