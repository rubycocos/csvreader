# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser.rb


require 'helper'

class TestParser < MiniTest::Test


def parser
  CsvYaml
end


def records   ## "standard" records for testing
  [[1, "John", "12 Totem Rd. Aspen",             true],
   [2, "Bob",  nil,                              false],
   [3, "Sue",  "Bigsby, 345 Carnival, WA 23009", false]]
end



def test_parse
  assert_equal records, parser.parse( <<TXT )
1,John,12 Totem Rd. Aspen,true
2,Bob,null,false
3,Sue,"Bigsby, 345 Carnival, WA 23009",false
TXT

  assert_equal records, parser.parse( <<TXT )
# hello world

1,John,12 Totem Rd. Aspen,true
2,Bob,null,false
3,Sue,"Bigsby, 345 Carnival, WA 23009",false
TXT

  assert_equal records, parser.parse( <<TXT )
  # hello world (pretty printed)

  1, John, 12 Totem Rd. Aspen,               true
  2, Bob,  null,                             false
  3, Sue,  "Bigsby, 345 Carnival, WA 23009", false

  # try more comments and empty lines

TXT


  txt =<<TXT
  # hello world
  1,John,12 Totem Rd. Aspen,true
  2,Bob,null,false
  3,Sue,"Bigsby, 345 Carnival, WA 23009",false
TXT

  recs = []
  parser.parse( txt ) { |rec| recs << rec }
  assert_equal records, recs
end


def test_read
  assert_equal records, parser.read( "#{CsvYaml.test_data_dir}/hello.yaml.csv" )
  assert_equal records, parser.read( "#{CsvYaml.test_data_dir}/hello11.yaml.csv" )
end


def test_open
  assert_equal records, parser.open( "#{CsvYaml.test_data_dir}/hello.yaml.csv", "r:bom|utf-8" ).read
  assert_equal records, parser.open( "#{CsvYaml.test_data_dir}/hello11.yaml.csv", "r:bom|utf-8" ).read
end


def test_foreach
  recs = []
  parser.foreach( "#{CsvYaml.test_data_dir}/hello.yaml.csv" ) { |rec| recs << rec }
  assert_equal records, recs

  recs = []
  parser.foreach( "#{CsvYaml.test_data_dir}/hello11.yaml.csv" ) { |rec| recs << rec }
  assert_equal records, recs
end


def test_enum
  csv = CsvYaml.new( <<TXT )
  # hello world

  1,John,12 Totem Rd. Aspen,true
  2,Bob,null,false
  3,Sue,"Bigsby, 345 Carnival, WA 23009",false
TXT

  it = csv.to_enum
  assert_equal [1, "John", "12 Totem Rd. Aspen",             true],  it.next
  assert_equal [2, "Bob",  nil,                              false], it.next
  assert_equal [3, "Sue",  "Bigsby, 345 Carnival, WA 23009", false], it.next
end

end # class TestParser
