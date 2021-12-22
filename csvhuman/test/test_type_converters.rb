# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_type_converters.rb



require 'helper'

class TestTypeConverters < MiniTest::Test

def conv_to_i( value )
  CsvHuman::TYPE_CONVERTERS[Integer].call( value )
end

def conv_to_f( value )
  CsvHuman::TYPE_CONVERTERS[Float].call( value )
end

def conv_to_date( value )
  CsvHuman::TYPE_CONVERTERS[Date].call( value )
end



def test_integer
  assert_equal 0,    conv_to_i( "0" )
  assert_equal 2011, conv_to_i( "2011" )
end

def test_float
  assert_equal 0.0,    conv_to_f( "0" )
  assert_equal 2011.0, conv_to_f( "2011" )
end

def test_date
  assert_equal Date.new( 2011, 12, 25 ), conv_to_date( "2011-12-25")
end


end # class TestTypeConverters
