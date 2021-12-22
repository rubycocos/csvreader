# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_misc.rb


require 'helper'

class TestMisc < MiniTest::Test


def test_airports
  recs = CsvHuman.read( "#{CsvHuman.test_data_dir}/airports.csv" )
  pp recs
end

def test_unhcr
  recs = CsvHuman.read( "#{CsvHuman.test_data_dir}/unhcr.csv" )
  pp recs
end

def test_ebola
  recs = CsvHuman.read( "#{CsvHuman.test_data_dir}/ebola.csv" )
  pp recs
end

end # class TestMisc
