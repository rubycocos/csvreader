# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader.rb


require 'helper'

class TestReader < MiniTest::Test


def test_parse

txt1 = <<TXT
a\tb\tc
1\t2\t3
4\t5\t6
TXT

txt2 = <<TXT
a	b	c	d
1	2	3	4
5	6	7	8
TXT

puts "== parse:"
pp TabReader.parse( txt1 )

puts "== parse:"
pp TabReader.parse( txt2 )

puts "== parse_line:"
pp TabReader.parse_line( "1\t2\t3" )

puts "== parse_line:"
pp TabReader.parse_line( "1	2	3	4" )

puts "== parse_line:"
pp TabReader.parse_line( "1\t2\t3\r\n" )

  assert true
end


def test_read

puts "== read:"
pp TabReader.read( "#{TabReader.test_data_dir}/test.tab" )
puts "== header:"
pp TabReader.header( "#{TabReader.test_data_dir}/test.tab" )
puts "== foreach:"
TabReader.foreach( "#{TabReader.test_data_dir}/test.tab" ) do |row|
  pp row
end
end


def test_read_empty

puts "== read (empty):"
pp TabReader.read( "#{TabReader.test_data_dir}/empty.tab" )
puts "== header (empty):"
pp TabReader.header( "#{TabReader.test_data_dir}/empty.tab" )
puts "== foreach (empty):"
TabReader.foreach( "#{TabReader.test_data_dir}/empty.tab" ) do |row|
	pp row
end
puts "== parse (empty):"
pp TabReader.parse( "" )
pp TabReader.parse_line( "" )
end

end
