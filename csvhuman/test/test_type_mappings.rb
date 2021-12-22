# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_type_mappings.rb



require 'helper'

class TestTypeMappings < MiniTest::Test

def split( value )
  parts = CsvHuman::Tag.split( value )

  name       = parts[0]
  attributes = parts[1..-1]   ## todo/fix: check if nil (make it empty array [] always) - why? why not?

  [name, attributes]
end


def conv_guess( value )
  CsvHuman.guess_type( *split(value) )
end

def conv_default( value )
  CsvHuman::TYPE_MAPPINGS[:default].call( *split(value) )
end

def conv_none( value )
  CsvHuman::TYPE_MAPPINGS[:none].call( *split(value) )
end



def test_none
  assert_equal String, conv_none( "#date" )
  assert_equal String, conv_none( "#date +year" )
  assert_equal String, conv_none( "#geo +lat" )
  assert_equal String, conv_none( "#geo +elevation" )
end

def test_guess_and_default
  assert_equal Date,    conv_guess( "#date" )
  assert_equal Integer, conv_guess( "#date +year" )
  assert_equal Float,   conv_guess( "#geo +lat" )
  assert_equal Float,   conv_guess( "#geo +elevation" )

  assert_equal Date,    conv_default( "#date" )
  assert_equal Integer, conv_default( "#date +year" )
  assert_equal Float,   conv_default( "#geo +lat" )
  assert_equal Float,   conv_default( "#geo +elevation" )
end


end # class TestTypeMappings
