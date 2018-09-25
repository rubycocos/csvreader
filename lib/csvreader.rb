# encoding: utf-8

require 'csv'
require 'json'
require 'pp'
require 'logger'


###
# our own code
require 'csvreader/version' # let version always go first
require 'csvreader/buffer'
require 'csvreader/parser'
require 'csvreader/reader'


puts CsvReader.banner   # say hello
