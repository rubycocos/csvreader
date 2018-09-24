# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_formats.rb


require 'helper'

class TestParserFormats < MiniTest::Test

def setup
  CsvReader::Parser.debug = true   ## turn on "global" logging - move to helper - why? why not?
end

def parser
  CsvReader::Parser
end


def test_parse_whitespace
   records = [["a", "b", "c"],
              ["1", "2", "3"]]

   ## don't care about newlines (\r\n) ??? - fix? why? why not?
   assert_equal records, parser.default.parse( "a,b,c\n1,2,3" )
   assert_equal records, parser.default.parse( "a,b,c\n1,2,3\n" )
   assert_equal records, parser.default.parse( " a, b ,c \n\n1,2,3\n" )
   assert_equal records, parser.default.parse( " a, b ,c \n \n1,2,3\n" )

   assert_equal [["a", "b", "c"],
                 [""],
                 ["1", "2", "3"]], parser.default.parse( %Q{a,b,c\n""\n1,2,3\n} )
   assert_equal [["", ""],
                 [""],
                 ["", "", ""]], parser.default.parse( %Q{,\n""\n"","",""\n} )


   ## strict rfc4180 - no trim leading or trailing spaces or blank lines
   assert_equal records,   parser.rfc4180.parse( "a,b,c\n1,2,3" )
   assert_equal [["a", "b", "c"],
                 [""],
                 ["1", "2", "3"]], parser.rfc4180.parse( "a,b,c\n\n1,2,3" )
   assert_equal [[" a", " b ", "c "],
                 [""],
                 ["1", "2", "3"]], parser.rfc4180.parse( " a, b ,c \n\n1,2,3" )
    assert_equal [[" a", " b ", "c "],
                  [" "],
                  ["",""]
                  ["1", "2", "3"]], parser.rfc4180.parse( " a, b ,c \n \n,\n1,2,3" )
end


def test_parse_empties
    assert_equal [], parser.default.parse( "\n \n \n" )

    ## strict rfc4180 - no trim leading or trailing spaces or blank lines
    assert_equal [[""],
                  [" "],
                  [" "]], parser.rfc4180.parse( "\n \n \n" )
    assert_equal [[""],
                  [" "],
                  [" "]], parser.rfc4180.parse( "\n \n " )

    assert_equal [[""]], parser.rfc4180.parse( "\n" )
    assert_equal [],     parser.rfc4180.parse( "" )
end

end # class TestParserFormats
