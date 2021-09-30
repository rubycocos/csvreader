# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_null.rb


require 'helper'


class TestParserNull < MiniTest::Test


def parser
  CsvReader::Parser
end


def test_escaped_mysql_null_value
  ## MySQL uses \N to symbolize null values. We have to restore this

    ## note: "unknown escape sequences e.g. \N get passed "through" as-is (unescaped)"
    ##   only supports \n \r  (sep e.g \, or \t)  (quote e.g. \") for now - any others?
    assert_equal [[ "character\\NEscaped" ]],
                 parser.default.parse( "character\\NEscaped" )

    assert_equal [[ "character\\NEscaped" ]],
                 parser.strict.parse( "character\\NEscaped" )
end


def test_mysql_null_value
  default_null_values = parser.default.config[:null]  ## save default null settings

  assert_equal [[ nil, nil, "" ]],
               parser.default.parse( "\\N, \\N ," )

  ## escaped with quotes
  assert_equal [[ "\\N", "\\N", "" ]],
               parser.default.parse( %Q{"\\N", "\\N" ,} )

  ## try single \N setting
  parser.default.null = "\\N"
  assert_equal [[ nil, nil, "" ]],
               parser.default.parse( "\\N, \\N ," )

  ## try no null values setting
  parser.default.null = nil
  assert_equal [[ "\\N", "\\N", "" ]],
               parser.default.parse( "\\N, \\N ," )

  ## try postgresql unquoted empty string is nil/null
  parser.default.null = ""
  assert_equal [[ nil, nil, "" ],
                [ nil, nil, "", nil ]],
               parser.default.parse( %Q{,,""\n ,  , "" ,} )

  ## try proc
  parser.default.null = ->(value) { value.downcase == 'nil' }
  assert_equal [[ nil, nil, nil, "" ]],
               parser.default.parse( "nil, Nil, NIL," )

  ## try array
  parser.default.null = ['nil', 'Nil', 'NIL']
  assert_equal [[ nil, nil, nil, "" ]],
                parser.default.parse( "nil, Nil, NIL," )

  ## restore defaults
  parser.default.null = default_null_values  ## ['\N', 'NA']
end


def test_strict_mysql_null_value
  assert_equal [[ "\\N", " \\N ", "" ]],
               parser.strict.parse( "\\N, \\N ," )

  ## try single \N setting
  parser.strict.null = "\\N"
  assert_equal [[ nil, nil, " \\N", "\\N ", "" ]],
               parser.strict.parse( "\\N,\\N, \\N,\\N ," )

  ## escaped with quotes
  assert_equal [[ "\\N", "\\N", nil, "" ]],
               parser.strict.parse( %Q{"\\N","\\N",\\N,} )


  ## try postgresql unquoted empty string is nil/null
  parser.strict.null = ""
  assert_equal [[ nil, nil, "" ],
                [ " ", "  ", "", nil ]],
               parser.strict.parse( %Q{,,""\n ,  ,"",} )

  ## try proc
  parser.strict.null = ->(value) { value.downcase == 'nil' }
  assert_equal [[ nil, nil, nil, "" ]],
               parser.strict.parse( "nil,Nil,NIL," )

  ## try array
  parser.strict.null = ['nil', 'Nil', 'NIL']
  assert_equal [[ nil, nil, nil, "" ]],
                parser.strict.parse( "nil,Nil,NIL," )

  ## restore defaults
  parser.strict.null = nil
end

end # class TestParserNull
