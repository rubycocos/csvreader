# encoding: utf-8


require 'pp'
require 'logger'


###
# our own code
require 'csvreader/version' # let version always go first
require 'csvreader/buffer'
require 'csvreader/parser_std'      # best practices pre-configured out-of-the-box
require 'csvreader/parser_strict'   # flexible (strict - no leading/trailing space triming, blanks, etc.), configure for different formats/dialects
require 'csvreader/parser_tab'
require 'csvreader/parser'
require 'csvreader/reader'
require 'csvreader/reader_hash'



## add convenience / shortcut alias
Csv     = CsvReader
CsvHash = CsvHashReader



puts CsvReader.banner   # say hello
