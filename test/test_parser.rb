# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser.rb


require 'helper'

class TestParser < MiniTest::Test


def parser
  CsvReader::Parser::DEFAULT
end


def test_parser_default
  pp CsvReader::Parser::DEFAULT
  pp CsvReader::Parser.default
  assert true
end

def test_parse
  records = [["a", "b", "c"],
             ["1", "2", "3"],
             ["4", "5", "6"]]

  ## don't care about newlines (\r\n)
  assert_equal records, parser.parse( "a,b,c\n1,2,3\n4,5,6" )
  assert_equal records, parser.parse( "a,b,c\n1,2,3\n4,5,6\n" )
  assert_equal records, parser.parse( "a,b,c\r1,2,3\r4,5,6" )
  assert_equal records, parser.parse( "a,b,c\r\n1,2,3\r\n4,5,6\r\n" )

  ## or leading and trailing spaces
  assert_equal records, parser.parse( "    \n a , b , c \n 1,2  ,3 \n 4,5,6   " )
  assert_equal records, parser.parse( "\n\na,  b,c   \n  1, 2, 3\n 4, 5, 6" )
  assert_equal records, parser.parse( "   \"a\"  , b ,  \"c\"   \n1,  2,\"3\"   \n4,5,  \"6\"" )
  assert_equal records, parser.parse( "a, b, c\n1,  2,3\n\n\n4,5,6\n\n\n" )
  assert_equal records, parser.parse( " a, b ,c  \n 1 , 2 , 3 \n4,5,6  " )
end


def test_parse_space
  records = [["1", "Man City"],
             ["2", "Liverpool"],
             ["3", "Chelsea"],
             ["4", "Arsenal"],
             ["8", "Man Utd"],
             ["13", "West Ham"],
             ["14", "Crystal Palace"]]

  parser.space='_'

  assert_equal records, parser.parse( <<TXT )
      1, Man_City
      2, Liverpool
      3, Chelsea
      4, Arsenal
      8, Man_Utd
     13, West_Ham
     14, Crystal_Palace
TXT

  assert_equal [[" "," ","  "]], parser.parse( "_ , _ , __" )


  parser.space='•'

  assert_equal records, parser.parse( <<TXT )
      1, Man•City
      2, Liverpool
      3, Chelsea
      4, Arsenal
      8, Man•Utd
     13, West•Ham
     14, Crystal•Palace
TXT

  assert_equal [[" "," ","  "]], parser.parse( "• , • , ••" )

  parser.space = nil  ## reset to default setting
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

   assert_equal records, parser.parse( " a;  b ; c\n1; 2;  3\n 4; 5;6   ",  sep: ';' )
   assert_equal records, parser.parse( "a; b; c\n  1; 2 ;3 \n4;5;6\n",      sep: ';' )
end

def test_parse_pipe   # or bar e.g. |||
   records = [["a", "b", "c"],
              ["1", "2", "3"],
              ["4", "5", "6"]]

   ## don't care about newlines (\r\n) ??? - fix? why? why not?
   assert_equal records, parser.parse( "a|b|c\n1|2|3\n4|5|6",         sep: '|' )
   assert_equal records, parser.parse( "a|b|c\n1|2|3\n4|5|6\n",       sep: '|' )
   assert_equal records, parser.parse( "a|b|c\r1|2|3\r4|5|6",         sep: '|' )
   assert_equal records, parser.parse( "a|b|c\r\n1|2|3\r\n4|5|6\r\n", sep: '|' )

   assert_equal records, parser.parse( " a|  b | c\n1| 2|  3\n 4| 5|6   ",  sep: '|' )
   assert_equal records, parser.parse( "a| b| c\n  1| 2 |3 \n4|5|6\n",      sep: '|' )
end



def test_parse_quotes
  records = [["a", "b", "c"],
             ["11 \n 11", "\"2\"", "3"]]

  assert_equal records, parser.parse( " a, b ,c  \n\"11 \n 11\", \"\"\"2\"\"\" , 3 \n" )
  assert_equal records, parser.parse( "\n\n \"a\", \"b\" ,\"c\"  \n  \"11 \n 11\"  ,  \"\"\"2\"\"\" , 3 \n" )
end

def test_parse_empties
  records = [["", "", ""]]

  assert_equal records, parser.parse( ",," )
  assert_equal records, parser.parse( <<TXT )
  "","",""
TXT

  assert_equal [], parser.parse( "" )
end


def test_parse_comments
  records = [["a", "b", "c"],
             ["1", "2", "3"]]

  assert_equal records, parser.parse( <<TXT )
# comment
# comment
## comment

a, b, c
1, 2, 3

TXT

  assert_equal records, parser.parse( <<TXT )
   a,   b,   c
   1,   2,   3

   # comment
   # comment
   ## comment
TXT
end

end # class TestParser
