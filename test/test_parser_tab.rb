# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_tab.rb


require 'helper'

class TestParserTab < MiniTest::Test


def parser
  CsvReader::Parser::TAB
end


def test_parser_tab
  pp CsvReader::Parser::TAB
  pp CsvReader::Parser.tab
  assert true
end

def test_parse
  records = [["a", "b", "c"],
             ["1", "2", "3"],
             ["4", "5", "6"]]

  ## don't care about newlines (\r\n)
  assert_equal records, parser.parse( "a\tb\tc\n1\t2\t3\n4\t5\t6" )
  assert_equal records, parser.parse( "a\tb\tc\n1\t2\t3\n4\t5\t6\n" )
  assert_equal records, parser.parse( "a\tb\tc\r\n1\t2\t3\r\n4\t5\t6\r\n" )
end

def test_parse_empties
  # note: trailing empty fields got (auto-)trimmed !!!!!!!;
  #        add missing -1 limit option :-) now works
  assert_equal [["","",""]],        parser.parse( "\t\t" )
  assert_equal [["","","","",""]],  parser.parse( "\t\t\t\t" )
  assert_equal [["1","",""]],       parser.parse( "1\t\t" )
  assert_equal [["1","","","",""]], parser.parse( "1\t\t\t\t" )
  assert_equal [["","","3"]],       parser.parse( "\t\t3" )
  assert_equal [["","","","","5"]], parser.parse( "\t\t\t\t5" )

  assert_equal [], parser.parse( "" )
end


end # class TestParserTab
