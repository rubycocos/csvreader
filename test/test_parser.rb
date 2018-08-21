# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser.rb


require 'helper'

class TestParser < MiniTest::Test


def test_parse1
   records = [["a", "b", "c"],
              ["1", "2", "3"],
              ["4", "5", "6"]]

   ## don't care about newlines (\r\n)
   assert_equal records, CsvReader::Parser.parse( "a,b,c\n1,2,3\n4,5,6" )
   assert_equal records, CsvReader::Parser.parse( "a,b,c\n1,2,3\n4,5,6\n" )
   assert_equal records, CsvReader::Parser.parse( "a,b,c\r1,2,3\r4,5,6" )
   assert_equal records, CsvReader::Parser.parse( "a,b,c\r\n1,2,3\r\n4,5,6\r\n" )

   ## or leading and trailing spaces
   assert_equal records, CsvReader::Parser.parse( "    \n a , b , c \n 1,2  ,3 \n 4,5,6   " )
   assert_equal records, CsvReader::Parser.parse( "\n\na,  b,c   \n  1, 2, 3\n 4, 5, 6" )
   assert_equal records, CsvReader::Parser.parse( "   \"a\"  , b ,  \"c\"   \n1,  2,\"3\"   \n4,5,  \"6\"" )
   assert_equal records, CsvReader::Parser.parse( "a, b, c\n1,  2,3\n\n\n4,5,6\n\n\n" )
   assert_equal records, CsvReader::Parser.parse( " a, b ,c  \n 1 , 2 , 3 \n4,5,6  " )
end


def test_parse_quotes
  records = [["a", "b", "c"],
             ["11 \n 11", "\"2\"", "3"]]

  assert_equal records, CsvReader::Parser.parse( " a, b ,c  \n\"11 \n 11\", \"\"\"2\"\"\" , 3 \n" )
  assert_equal records, CsvReader::Parser.parse( "\n\n \"a\", \"b\" ,\"c\"  \n  \"11 \n 11\"  ,  \"\"\"2\"\"\" , 3 \n" )
end

def test_parse_empties
  records = [["", "", ""]]

  assert_equal records, CsvReader::Parser.parse( ",," )
  assert_equal records, CsvReader::Parser.parse( <<TXT )
  "","",""
TXT

  assert_equal [], CsvReader::Parser.parse( "" )
end


def test_parse_comments
  records = [["a", "b", "c"],
             ["1", "2", "3"]]

  assert_equal records, CsvReader::Parser.parse( <<TXT )
# comment
# comment
## comment

a, b, c
1, 2, 3

TXT

  assert_equal records, CsvReader::Parser.parse( <<TXT )
   a,   b,   c
   1,   2,   3

   # comment
   # comment
   ## comment
TXT
end

end # class TestParser
