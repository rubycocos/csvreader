# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_header_converter.rb



require 'helper'

class TestHeaderConverter < MiniTest::Test

def conv_none( value )
  CsvHuman::HEADER_CONVERTERS[:none].call( value )
end

def conv_default( value )
  CsvHuman::HEADER_CONVERTERS[:default].call( value )
end

def conv_symbol( value )
  CsvHuman::HEADER_CONVERTERS[:symbol].call( value )
end



def test_none
  assert_equal "#sector", conv_none( "#sector" )
  assert_equal "#adm1",   conv_none( "#adm1" )

  assert_equal "#sector +en", conv_none( "#sector +en" )
  assert_equal "#adm1 +code", conv_none( "#adm1 +code" )

  assert_equal "#affected +children +f",             conv_none( "#affected +children +f" )
  assert_equal "#population +affected +children +m", conv_none( "#population +affected +children +m" )
end


def test_default
  assert_equal "sector", conv_default( "#sector" )
  assert_equal "adm1",   conv_default( "#adm1" )

  assert_equal "sector+en", conv_default( "#sector +en" )
  assert_equal "adm1+code", conv_default( "#adm1 +code" )

  assert_equal "affected+children+f",            conv_default( "#affected +children +f" )
  assert_equal "population+affected+children+m", conv_default( "#population +affected +children +m" )
end


def test_symbol
  assert_equal :sector, conv_symbol( "#sector" )
  assert_equal :adm1,   conv_symbol( "#adm1" )

  assert_equal :sector_en, conv_symbol( "#sector +en" )
  assert_equal :adm1_code, conv_symbol( "#adm1 +code" )

  assert_equal :affected_children_f,            conv_symbol( "#affected +children +f" )
  assert_equal :population_affected_children_m, conv_symbol( "#population +affected +children +m" )
end


end # class TestHeaderConverter
