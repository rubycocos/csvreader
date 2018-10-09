# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader_converters.rb


require 'helper'

class TestReaderConverters < MiniTest::Test


def test_all
  rows = CsvReader.parse( <<TXT, :converters => :all )
1,2,3
true,false,null
,,
TXT

  pp rows

  assert_equal 3, rows.size
  assert_equal [1,2,3],          rows[0]
  assert_equal [true,false,nil], rows[1]
  assert_equal [nil,nil,nil],    rows[2]
end


def test_all_quotes
  ## only convert unquoted values - why? why not?
  ##   e.g.  1      =>  1 (integer)
  ##         "1"    => "1" (string)
  ##         true   => true (boolean)
  ##         "true" => "true" (string)
  ##
  ##
  ##  note: use CsvRecord for by column types / converters

  rows = CsvReader.parse( <<TXT, :converters => :all )
"1","2","3"
"true","false","null"
"","",""
TXT

  pp rows

  assert_equal 3, rows.size
  assert_equal [1,2,3],          rows[0]
  assert_equal [true,false,nil], rows[1]
  assert_equal [nil,nil,nil],    rows[2]
end


end # class TestReaderConverters
