# encoding: utf-8

require 'pp'
require 'yaml'
require 'logger'

## our own code
require 'csvyaml/version'    # note: let version always go first
require 'csvyaml/parser'



## add some "alternative" shortcut aliases
CSV_YAML = CsvYaml
CSVYAML  = CsvYaml
CSVY     = CsvYaml
CsvY     = CsvYaml


# say hello
puts CsvYaml.banner     if $DEBUG || (defined?($RUBYCOCO_DEBUG) && $RUBYCOCO_DEBUG)
