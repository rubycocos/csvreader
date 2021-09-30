# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_buffer.rb


require 'helper'


class TestBuffer < MiniTest::Test


def test_peek

  buf = CsvReader::Buffer.new( <<TXT )
# hello
1,2,3
TXT

  assert_equal '#',    buf.peek
  assert_equal '#',    buf.peek1
  assert_equal '#',    buf.peekn(1)
  assert_equal '# ',   buf.peekn(2)
  assert_equal '# h',  buf.peekn(3)
  assert_equal '# he', buf.peekn(4)

  buf.getc   ## eat first char

  assert_equal ' ',    buf.peek
  assert_equal ' ',    buf.peek1
  assert_equal ' ',    buf.peekn(1)
  assert_equal ' h',   buf.peekn(2)
  assert_equal ' he',  buf.peekn(3)
  assert_equal ' hel', buf.peekn(4)
end


end # class TestBuffer
