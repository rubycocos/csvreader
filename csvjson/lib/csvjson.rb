# encoding: utf-8

require 'pp'
require 'json'
require 'logger'


## our own code
##   todo/check: use require_relative - why? why not?
require 'csvjson/version'    # note: let version always go first
require 'csvjson/parser'


## add some "alternative" shortcut aliases
CSV_JSON = CsvJson
CSVJSON  = CsvJson
CSVJ     = CsvJson
CsvJ     = CsvJson


# say hello
puts CsvJson.banner    if $DEBUG || (defined?($RUBYCOCO_DEBUG) && $RUBYCOCO_DEBUG)
