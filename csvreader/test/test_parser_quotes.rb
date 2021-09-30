# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_quotes.rb


require 'helper'


class TestParserQuotes < MiniTest::Test


def parser
  CsvReader::Parser::DEFAULT
end


def test_french_single
  assert_equal [[ "a", "b", "c" ]],
               parser.parse( " ‹a›, ‹b›, ›c‹ " )

  assert_equal [[ "a,1", " b,2", "c, 3" ]],
               parser.parse( " ‹a,1›, ‹ b,2›, ›c, 3‹ " )

  assert_equal [[ %Q{"a"}, %Q{'b'}, %Q{c'"'"} ]],
               parser.parse( %Q{ ‹"a"›, ‹'b'›, ›c'"'"‹} )

  # note: quote matches only if first non-whitespace char
  assert_equal [[ "_‹a›", "_‹b›", "›c‹" ]],
               parser.parse( %Q{ _‹a›, _‹b›, "›c‹"} )

end


def test_french_double
  assert_equal [[ "a", "b", "c" ]],
               parser.parse( " «a», «b», »c« " )

  assert_equal [[ "a,1", " b,2", "c, 3" ]],
               parser.parse( " «a,1», « b,2», »c, 3« " )

  assert_equal [[ %Q{"a"}, %Q{'b'}, %Q{c'"'"} ]],
               parser.parse( %Q{ «"a"», «'b'», »c'"'"«} )

  # note: quote matches only if first non-whitespace char
  assert_equal [[ "_«a»", "_«b»", "»c«" ]],
               parser.parse( %Q{ _«a», _«b», "»c«"} )

end


end # class TestParserQuotes
