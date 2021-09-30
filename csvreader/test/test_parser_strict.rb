# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_strict.rb


require 'helper'

class TestParserStrict < MiniTest::Test


def parser
  CsvReader::Parser::STRICT
end


def test_parser_strict
  pp CsvReader::Parser::STRICT
  pp CsvReader::Parser.strict
  assert true
end

def test_parse
   records = [["a", "b", "c"],
              ["1", "2", "3"],
              ["4", "5", "6"]]

   ## don't care about newlines (\r\n) ??? - fix? why? why not?
   assert_equal records, parser.parse( "a,b,c\n1,2,3\n4,5,6" )
   assert_equal records, parser.parse( "a,b,c\n1,2,3\n4,5,6\n" )
   assert_equal records, parser.parse( "a,b,c\r1,2,3\r4,5,6" )
   assert_equal records, parser.parse( "a,b,c\r\n1,2,3\r\n4,5,6\r\n" )
end

def test_parse_semicolon
   records = [["a", "b", "c"],
              ["1", "2", "3"],
              ["4", "5", "6"]]

   ## don't care about newlines (\r\n) ??? - fix? why? why not?
   assert_equal records, parser.parse( "a;b;c\n1;2;3\n4;5;6",         sep: ';' )
   assert_equal records, parser.parse( "a;b;c\n1;2;3\n4;5;6\n",       sep: ';' )
   assert_equal records, parser.parse( "a;b;c\r1;2;3\r4;5;6",         sep: ';' )
   assert_equal records, parser.parse( "a;b;c\r\n1;2;3\r\n4;5;6\r\n", sep: ';' )
end

def test_parse_tab
   records = [["a", "b", "c"],
              ["1", "2", "3"],
              ["4", "5", "6"]]

   ## don't care about newlines (\r\n) ??? - fix? why? why not?
   assert_equal records, parser.parse( "a\tb\tc\n1\t2\t3\n4\t5\t6",         sep: "\t" )
   assert_equal records, parser.parse( "a\tb\tc\n1\t2\t3\n4\t5\t6\n",       sep: "\t" )
   assert_equal records, parser.parse( "a\tb\tc\r1\t2\t3\r4\t5\t6",         sep: "\t" )
   assert_equal records, parser.parse( "a\tb\tc\r\n1\t2\t3\r\n4\t5\t6\r\n", sep: "\t" )
end



def test_parse_empties
  assert_equal [["","",""],["","",""]],
               parser.parse( %Q{"","",""\n,,} )

  parser.null = ""
  assert_equal [["","",""," "],[nil,nil,nil," "]],
               parser.parse( %Q{"","",""," "\n,,, } )
  parser.null = [""]   ## try array (allows multiple null values)
  assert_equal [[nil,nil,nil," "],["","",""," "]],
               parser.parse( %Q{,,, \n"","",""," "} )

  ## reset to defaults
  parser.null = nil
  assert_equal [["","",""],["","",""]],
               parser.parse( %Q{"","",""\n,,} )
end


end # class TestParserStrict
