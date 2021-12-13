# encoding: utf-8


require 'pp'
require 'logger'


###
# our own code
#   check: use require_relative - why? why not?
require 'tabreader/version' # let version always go first
require 'tabreader/reader'
require 'tabreader/reader_hash'



## add some "convenience" shortcuts
TAB     = TabReader
Tab     = TabReader
TabHash = TabHashReader


# say hello
puts TabReader.banner     if $DEBUG || (defined?($RUBYCOCO_DEBUG) && $RUBYCOCO_DEBUG)
