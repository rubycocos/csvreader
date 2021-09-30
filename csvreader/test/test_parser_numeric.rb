# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_numeric.rb


require 'helper'


class TestParserNumeric < MiniTest::Test

def parser
  CsvReader::Parser::NUMERIC
end


def test_parser_numeric
  pp CsvReader::Parser::NUMERIC
  pp CsvReader::Parser.numeric
  assert true
end

def test_parse
   assert_equal [[1.0,2.0,3.0],
                 [4.0,5.0,6.0]], parser.parse( "1,2,3\n4,5,6" )
   assert_equal [[1.0,2.0,3.0],
                 ["4","5","6"]], parser.parse( %Q{ 1,2 , 3\n"4","5","6"} )
   assert_equal [[1.0,2.0,3.0],
                ["4","5","6"]], parser.parse( %Q{ 1,2 , 3\n "4", "5" ,"6" } )
   assert_equal [["a","b","c"]], parser.parse( %Q{"a","b","c"} )
end


def test_empty
   assert_equal [[nil,nil,nil],
                 ["","",""]],    parser.parse( %Q{,,\n"","",""} )
end

end # class TestParserNumeric
