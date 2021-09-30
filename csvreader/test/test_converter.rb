# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_converter.rb


require 'helper'


class TestConverter < MiniTest::Test


def test_empty
  conv = CsvReader::Converter.create_converters( nil )
  pp conv

  assert_equal [],   conv.to_a
  assert_equal true, conv.empty?
end


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


def test_null
  conv = CsvReader::Converter.new( :null )
  pp conv

  assert_equal [CsvReader::Converter::CONVERTERS[:null]], conv.to_a

  assert_nil  conv.convert( "" )
  assert_nil  conv.convert( "NULL" )
  assert_nil  conv.convert( "null" )
  assert_nil  conv.convert( "#NA" )
  assert_nil  conv.convert( "N/A" )
end

def test_boolean
  conv = CsvReader::Converter.new( :boolean )
  pp conv

  assert_equal [CsvReader::Converter::CONVERTERS[:boolean]], conv.to_a

  assert_equal true, conv.convert( "TRUE" )
  assert_equal true, conv.convert( "true" )
  assert_equal true, conv.convert( "t" )
  assert_equal true, conv.convert( "ON" )
  assert_equal true, conv.convert( "on" )
  assert_equal true, conv.convert( "YES" )
  assert_equal true, conv.convert( "yes" )

  assert_equal false, conv.convert( "FALSE" )
  assert_equal false, conv.convert( "false" )
  assert_equal false, conv.convert( "f" )
  assert_equal false, conv.convert( "OFF" )
  assert_equal false, conv.convert( "off" )
  assert_equal false, conv.convert( "NO" )
  assert_equal false, conv.convert( "no" )
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

  assert_equal [CsvReader::Converter::CONVERTERS[:null],
                CsvReader::Converter::CONVERTERS[:boolean],
                CsvReader::Converter::CONVERTERS[:date_time],
                CsvReader::Converter::CONVERTERS[:integer],
                CsvReader::Converter::CONVERTERS[:float]], conv.to_a

  assert_nil  conv.convert( "" )
  assert_nil  conv.convert( "NULL" )
  assert_nil  conv.convert( "null" )
  assert_nil  conv.convert( "#NA" )
  assert_nil  conv.convert( "N/A" )

  assert_equal true, conv.convert( "TRUE" )
  assert_equal true, conv.convert( "true" )
  assert_equal true, conv.convert( "t" )
  assert_equal true, conv.convert( "ON" )
  assert_equal true, conv.convert( "on" )

  assert_equal false, conv.convert( "FALSE" )
  assert_equal false, conv.convert( "false" )
  assert_equal false, conv.convert( "f" )
  assert_equal false, conv.convert( "OFF" )
  assert_equal false, conv.convert( "off" )
end

end # class TestConverter
