# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_hdx.rb


require 'helper'

class TestHdxSamples < MiniTest::Test


def test_ebola
  recs = CsvHuman.read( "#{CsvHuman.test_data_dir}/hdx/ebola_treatment_centres.csv" )
  pp recs
end

def test_phl_haima
  recs = CsvHuman.read( "#{CsvHuman.test_data_dir}/hdx/phl_haima_houses_damaged.csv" )
  pp recs
end

def test_zika_cases
  recs = CsvHuman.read( "#{CsvHuman.test_data_dir}/hdx/zika_cases.csv" )
  pp recs
end

end # class TestHdxSamples
