# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_table.rb


require 'helper'

class TestParserTable < MiniTest::Test


def parser() CsvReader::Parser::TABLE;  end


def test_space
  records = [["1", "Man City", "10", "8", "2", "0", "27", "3", "24", "26"],
             ["2", "Liverpool", "10", "8", "2", "0", "20", "4", "16", "26"],
             ["3", "Chelsea", "10", "7", "3", "0", "24", "7", "17", "24"],
             ["4", "Arsenal", "10", "7", "1", "2", "24", "13", "11", "22"],
             ["8", "Man Utd", "10", "5", "2", "3", "17", "17", "0", "17"],
             ["13", "West Ham", "10", "2", "2", "6", "9", "15", "-6", "8"],
             ["14", "Crystal Palace", "10", "2", "2", "6", "7", "13", "-6", "8"]]

  parser.space='_'

  assert_equal records, parser.parse( <<TXT )
      1  Man_City 10 8 2 0 27 3 24 26
      2  Liverpool 10 8 2 0 20 4 16 26
      3  Chelsea 10 7 3 0 24 7 17 24
      4  Arsenal 10 7 1 2 24 13 11 22
      8  Man_Utd 10 5 2 3 17 17 0 17
      13  West_Ham 10 2 2 6 9 15 -6 8
      14  Crystal_Palace 10 2 2 6 7 13 -6 8
TXT

  assert_equal [[" "," ","  "]], parser.parse( "_ _ __" )


  parser.space='•'

  assert_equal records, parser.parse( <<TXT )
      1  Man•City 10 8 2 0 27 3 24 26
      2  Liverpool 10 8 2 0 20 4 16 26
      3  Chelsea 10 7 3 0 24 7 17 24
      4  Arsenal 10 7 1 2 24 13 11 22
      8  Man•Utd 10 5 2 3 17 17 0 17
      13  West•Ham 10 2 2 6 9 15 -6 8
      14  Crystal•Palace 10 2 2 6 7 13 -6 8
TXT

  assert_equal [[" "," ","  "]], parser.parse( "• • ••" )

  parser.space = nil  ## reset to default setting
end


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
