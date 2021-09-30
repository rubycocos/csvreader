# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_autofix.rb


require 'helper'


class TestParserAutofix < MiniTest::Test


def parser
  CsvReader::Parser::DEFAULT
end


def test_quote_with_trailing_value
  recs = [[ "Farrokh", "\"Freddy\" Mercury", "Bulsara" ]]

  assert_equal recs, parser.parse( %Q{Farrokh,"Freddy" Mercury,Bulsara} )
  assert_equal recs, parser.parse( %Q{  Farrokh , "Freddy" Mercury  , Bulsara } )
  assert_equal recs, parser.parse( %Q{Farrokh,  "Freddy" Mercury   ,Bulsara} )
end


end # class TestParserAutofix
