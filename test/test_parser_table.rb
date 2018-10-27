# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_table.rb


require 'helper'

class TestParserTable < MiniTest::Test


def parser() CsvReader::Parser::TABLE;  end


def test_contacts
  records = [["aa", "bbb"],
             ["cc", "dd", "ee"]]

  assert_equal records, parser.parse( <<TXT )
# space-separated with comments and blank lines

 aa bbb
cc    dd ee

TXT

   assert_equal records, parser.parse( <<TXT )
 aa bbb
cc    dd ee
TXT
end


end # class TestParserTable
