# encoding: utf-8

###
# 3rd party gems
require 'record'
require 'csvreader'


###
# our own code
require 'csvrecord/version' # let version always go first
require 'csvrecord/base'


# say hello
puts CsvRecord.banner     if $DEBUG || (defined?($RUBYCOCO_DEBUG) && $RUBYCOCO_DEBUG)
