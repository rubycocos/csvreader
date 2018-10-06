# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_converter.rb


require 'helper'


class TestConverter < MiniTest::Test

def test_downcase
  conv = CsvReader::Converter.create_header_converters( :downcase )
  pp conv

  assert_equal [CsvReader::Converter::HEADER_CONVERTERS[:downcase]], conv.to_a

  assert_equal "hello",         conv.convert( "HELLO" )
  assert_equal "hello, world!", conv.convert( "HELLO, WORLD!" )
end


def test_symbol
  conv = CsvReader::Converter.create_header_converters( :symbol )
  pp conv

  assert_equal [CsvReader::Converter::HEADER_CONVERTERS[:symbol]], conv.to_a

  assert_equal :hello,       conv.convert( "HELLO" )
  assert_equal :hello_world, conv.convert( "HELLO, WORLD!" )
end



def test_integer
  conv = CsvReader::Converter.new( :integer )
  pp conv
  conv2 = CsvReader::Converter.create_converters( :integer )
  pp conv2

  assert_equal [CsvReader::Converter::CONVERTERS[:integer]], conv.to_a
  assert_equal [CsvReader::Converter::CONVERTERS[:integer]], conv2.to_a

  assert_equal 0,       conv.convert( "0" )
  assert_equal 1,       conv.convert( "1" )

  assert_equal "0.0",   conv.convert( "0.0" )
  assert_equal "1.0",   conv.convert( "1.0" )

  assert_equal 0,       conv.convert( "00" )
  assert_equal 1,       conv.convert( "01" )

  assert_equal "1st",   conv.convert( "1st" )
  assert_equal "1980s", conv.convert( "1980s" )

  assert_equal "",      conv.convert( "" )  ## try empty string edge case
end


def test_float
  conv = CsvReader::Converter.new( :float )
  pp conv
  conv2 =  CsvReader::Converter.create_converters( :float )
  pp conv2

  assert_equal [CsvReader::Converter::CONVERTERS[:float]], conv.to_a
  assert_equal [CsvReader::Converter::CONVERTERS[:float]], conv2.to_a

  assert_equal 0.0, conv.convert( "0" )
  assert_equal 1.0, conv.convert( "1" )

  assert_equal 0.0, conv.convert( "0.0" )
  assert_equal 1.0, conv.convert( "1.0" )

  assert_equal 0.0, conv.convert( "00" )
  assert_equal 1.0, conv.convert( "01" )

  assert_equal "1st",   conv.convert( "1st" )
  assert_equal "1980s", conv.convert( "1980s" )

  assert_equal "",      conv.convert( "" )  ## try empty string edge case
end


def test_numeric
  conv = CsvReader::Converter.new( :numeric )
  pp conv

  assert_equal [CsvReader::Converter::CONVERTERS[:integer],
                CsvReader::Converter::CONVERTERS[:float]], conv.to_a
end

def test_all
  conv = CsvReader::Converter.new( :all )
  pp conv

  assert_equal [CsvReader::Converter::CONVERTERS[:date_time],
                CsvReader::Converter::CONVERTERS[:integer],
                CsvReader::Converter::CONVERTERS[:float]], conv.to_a

end

end # class TestConverter
