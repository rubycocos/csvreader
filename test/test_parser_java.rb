# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_java.rb


require 'helper'

##########################
# try some tests from apache java (commons) csv reader
#  see https://github.com/apache/commons-csv/blob/master/src/test/java/org/apache/commons/csv/LexerTest.java


class TestParserJava < MiniTest::Test


LF	= "\n"     ##   \n == ASCII 0x0A (hex) 10 (dec) = LF (Newline/line feed)
CR	= "\r"     ##   \r == ASCII 0x0D (hex) 13 (dec) = CR (Carriage return)



def parser
  CsvReader::Parser
end

def test_surrounding_spaces_are_deleted
  assert_equal [["noSpaces",
                 "leadingSpaces",
                 "trailingSpaces",
                 "surroundingSpaces",
                 "",
                 "",
                 ""]], parser.default.parse( "noSpaces,  leadingSpaces,trailingSpaces  ,  surroundingSpaces  ,  ,," )
end


def test_surrounding_tabs_are_deleted
  assert_equal [["noTabs",
                 "leadingTab",
                 "trailingTab",
                 "surroundingTabs",
                 "",
                 "",
                 ""]], parser.default.parse( "noTabs,\tleadingTab,trailingTab\t,\tsurroundingTabs\t,\t\t,," )
end

def test_ignore_empty_lines
  assert_equal [[ "first", "line", "" ],
                [ "second", "line" ],
                [ "third line" ],
                [ "last", "line" ]],
                parser.default.parse( "first,line,\n" + "\n" + "\n" +
                              "second,line\n" + "\n" + "\n" +
                              "third line \n" + "\n" + "\n" +
                              "last, line \n" + "\n" + "\n" + "\n" )
end


def test_comments
  assert_equal [["first",  "line", "" ],
                ["second", "line", "tokenWith#no-comment" ],
                ["third",  "line", "#no-comment" ]],
                parser.default.parse( "first,line,\n" +
                              "second,line,tokenWith#no-comment\n" +
                              "# comment line \n" +
                              "third,line,#no-comment\n" +
                              "# penultimate comment\n" +
                              "# Final comment\n" )
end





def test_comments_and_empty_lines
  parser.rfc4180.config[:comment] = '#'

  assert_equal [[ "1", "2", "3", "" ], ## 1
                [ "" ], ## 1b
                [ "" ], ## 1c
                [ "a", "b x", "c#no-comment" ], ## 2
                [ "" ],  ## 4
                [ "" ],  ## 4b
                [ "d", "e", "#no-comment" ], ## 5
                [ "" ], ## 5b
                [ "" ], ## 5c
                [ "" ], ## 6b
                [ "" ]  ## 6c
               ],
               parser.rfc4180.parse(
                  "1,2,3,\n" + ## 1
                  "\n" +       ## 1b
                  "\n" +       ## 1c
                  "a,b x,c#no-comment\n" + ## 2
                  "#foo\n" + ## 3
                  "\n" + ## 4
                  "\n" + ## 4b
                  "d,e,#no-comment\n" + ## 5
                  "\n" + ## 5b
                  "\n" + ## 5c
                  "# penultimate comment\n" + ## 6
                  "\n" + ## 6b
                  "\n" + ## 6c
                  "# Final comment\n" ## 7
              )

  parser.rfc4180.config[:comment] = nil    ## reset to defaults
end


def test_backslash_with_escaping
  ## simple token with escaping enabled
  assert_equal [[ "a", ",", "b\\" ],
                [ ",", "\nc", "d\r" ],
                [ "e" ]],
                parser.default.parse( "a,\\,,b\\\\\n" +
                                      "\\,,\\\nc,d\\\r\n" +
                                      "e" )

  parser.rfc4180.config[:escape] = "\\"
  assert_equal [[ "a", ",", "b\\" ],
                [ ",", "\nc", "d\r" ],
                [ "e" ]],
                parser.rfc4180.parse( "a,\\,,b\\\\\n" +
                                      "\\,,\\\nc,d\\\r\n" +
                                      "e" )
  parser.rfc4180.config[:escape] = nil
end


def test_backslash_without_escaping
  ## simple token with escaping not enabled
  assert_equal [[ "a",
                  "\\", ## an unquoted single backslash is not an escape char
                  "",
                  "b\\" ## an unquoted single backslash is not an escape char
                ],
                [ "\\", "", "" ]],
               parser.rfc4180.parse( "a,\\,,b\\\n" +
                                     "\\,," )
end





def test_next_token4
  ## encapsulator tokenizer (single line)
  assert_equal [[ "a", "foo", "b" ],
                [ "a", " foo", "b" ],
                [ "a", "foo ", "b" ],
                [ "a", " foo ", "b" ]],
                parser.default.parse( "a,\"foo\",b\n" +
                                      "a,   \" foo\",b\n" +
                                      "a,\"foo \"  ,b\n" +
                                      "a,  \" foo \"  ,b" )
end


def test_next_token5
    ## encapsulator tokenizer (multi line, delimiter in string)
   assert_equal [[ "a", "foo\n", "b" ],
                 [ "foo\n  baar ,,," ],
                 [ "\n\t \n" ]],
                 parser.default.parse( "a,\"foo\n\",b\n" +
                                       "\"foo\n  baar ,,,\"\n" +
                                       "\"\n\t \n\"" )
end


def test_separator_is_tab
  parser.rfc4180.sep = "\t"
  assert_equal [["one",
                 "two",
                 "",
                 "four ",
                 " five",
                 " six" ]],
                 parser.rfc4180.parse( "one\ttwo\t\tfour \t five\t six" )
  parser.rfc4180.sep = ","   ## reset back to comma
end




def test_escaped_cr
    assert_equal [[ "character" + CR + "Escaped" ]],
                 parser.default.parse( "character\\" + CR + "Escaped" )
end


def test_cr
   assert_equal [[ "character"  ],
                 [ "NotEscaped" ]],
                parser.default.parse( "character" + CR + "NotEscaped" )
end



def test_escaped_lf
    assert_equal [[ "character" + LF + "Escaped" ]],
                 parser.default.parse( "character\\" + LF + "Escaped" )
end

def test_lf
   assert_equal [[ "character" ],
                 [ "NotEscaped" ]],
                 parser.default.parse( "character" + LF + "NotEscaped" )
end



def test_escaped_mysql_null_value
  ## MySQL uses \N to symbolize null values. We have to restore this

    ## note: "unknown escape sequences e.g. \N get passed "through" as-is (unescaped)"
    ##   only supports \n \r  (sep e.g \, or \t)  (quote e.g. \") for now - any others?
    assert_equal [[ "character\\NEscaped" ]],
                 parser.default.parse( "character\\NEscaped" )
end

end # class TestParserJava
