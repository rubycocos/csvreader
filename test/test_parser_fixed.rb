# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_fixed.rb


require 'helper'

class TestParserFixed < MiniTest::Test


def parser() CsvReader::Parser::FIXED;  end
def reader() CsvReader.fixed;           end


def test_width
   width( parser )
   width( reader )
end

def test_contacts
   contacts( parser )
   contacts( reader )
end


def width( parser )
  records = [["12345678","12345678", "12345678901234567890123456789012", "12345678901234"]]

  assert_equal records, parser.parse( <<TXT, width: [8,8,32,14] )
# fixed width with comments and blank lines

12345678123456781234567890123456789012345678901212345678901234

TXT

  assert_equal records, parser.parse( <<TXT, width: [8,8,32,14] )
12345678123456781234567890123456789012345678901212345678901234
TXT
end


def contacts( parser )
  records = [["John",    "Smith",    "john@example.com",    "1-888-555-6666"],
             ["Michele", "O'Reiley", "michele@example.com", "1-333-321-8765"]]

  assert_equal records, parser.parse( <<TXT, width: [8,8,32,14] )
# fixed width with comments and blank lines

John    Smith   john@example.com                1-888-555-6666
Michele O'Reileymichele@example.com             1-333-321-8765

TXT


   assert_equal records, parser.parse( <<TXT, width: [8,8,32,14] )
John    Smith   john@example.com                1-888-555-6666
Michele O'Reileymichele@example.com             1-333-321-8765
TXT
end


def test_contacts
  records = [["John",    "Smith",    "john@example.com",    "1-888-555-6666"],
             ["Michele", "O'Reiley", "michele@example.com", "1-333-321-8765"]]

  assert_equal records, parser.parse( <<TXT, width: [8,8,32,14] )
# fixed width with comments and blank lines

John    Smith   john@example.com                1-888-555-6666
Michele O'Reileymichele@example.com             1-333-321-8765

TXT


   assert_equal records, parser.parse( <<TXT, width: [8,8,32,14] )
John    Smith   john@example.com                1-888-555-6666
Michele O'Reileymichele@example.com             1-333-321-8765
TXT
end



end # class TestParserFixed
