# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader_hash.rb


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
pp TabHashReader.parse( txt1 )

puts "== parse:"
pp TabHashReader.parse( txt2 )

  assert true
end


def test_read

puts "== read:"
pp TabHashReader.read( "#{TabReader.test_data_dir}/test.tab" )
puts "== foreach:"
TabHashReader.foreach( "#{TabReader.test_data_dir}/test.tab" ) do |row|
  pp row
end
end


def test_read_empty

puts "== read (empty):"
pp TabHashReader.read( "#{TabReader.test_data_dir}/empty.tab" )
puts "== foreach (empty):"
TabHashReader.foreach( "#{TabReader.test_data_dir}/empty.tab" ) do |row|
	pp row
end
puts "== parse (empty):"
pp TabHashReader.parse( "" )
end

end
