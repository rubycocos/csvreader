# encoding: utf-8

###
## note: to run use:
##  ruby ./io/test/test_scanner.rb


require 'minitest/autorun'


require 'strscan'


class TestScanner  < MiniTest::Test


  NOT_COMMA_OR_NEWLINE_RX = /[^,\n\r]*/

  def test_line
    buf = StringScanner.new( "a,b,\r\n" )

    assert_equal "a",  buf.scan( NOT_COMMA_OR_NEWLINE_RX )
    assert_equal ",",  buf.peek(1)
    assert_equal ",",  buf.getch
    assert_equal "b",  buf.scan( NOT_COMMA_OR_NEWLINE_RX )
    assert_equal ",",  buf.peek(1)
    assert_equal ",",  buf.getch
    assert_equal "",   buf.scan( NOT_COMMA_OR_NEWLINE_RX )
    assert_equal "\r", buf.peek(1)
    assert_equal 2,    buf.skip( /\r?\n/ )
    assert buf.eos?
  end


  COMMA_LOOKAHEAD_RX = /(?=,|\n|\r) | $ /x

  def test_line_with_lookahead
    buf = StringScanner.new( "a,b,\r\n" )

    assert_equal "a",  buf.scan_until( COMMA_LOOKAHEAD_RX )
    assert_equal ",",  buf.peek(1)
    assert_equal ",",  buf.getch
    assert_equal "b",  buf.scan_until( COMMA_LOOKAHEAD_RX )
    assert_equal ",",  buf.peek(1)
    assert_equal ",",  buf.getch
    assert_equal "",   buf.scan_until( COMMA_LOOKAHEAD_RX )
    assert_equal "\r", buf.peek(1)
    assert_equal 2,    buf.skip( /\r?\n/ )
    assert buf.eos?
  end


  def test_empty
    buf = StringScanner.new( "" )

    assert_equal "", buf.scan_until( /$/ )
    assert_equal "", buf.scan_until( /$/ )
    assert buf.eos?

    assert_equal "", buf.scan_until( /(?=,) | $/x )
    assert_equal "", buf.scan_until( /(?=,) | $/x )
    assert buf.eos?

    assert_equal "", buf.scan( NOT_COMMA_OR_NEWLINE_RX )
    assert buf.eos?

    assert_equal "", buf.scan_until( COMMA_LOOKAHEAD_RX )
    assert buf.eos?
  end
end # class TestScanner
