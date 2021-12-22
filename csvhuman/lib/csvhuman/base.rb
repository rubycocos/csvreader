# encoding: utf-8

require 'csvreader/base'


## our own code
require 'csvhuman/version'    # note: let version always go first
require 'csvhuman/tag'
require 'csvhuman/column'
require 'csvhuman/converter'
require 'csvhuman/reader'

require 'csvhuman/doc/helper.rb'
require 'csvhuman/doc/schema.rb'


# say hello
puts CsvHuman.banner     if $DEBUG || (defined?($RUBYCOCO_DEBUG) && $RUBYCOCO_DEBUG)
