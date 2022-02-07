# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_import.rb


require 'helper'

class TestImport < MiniTest::Test

  def test_import

    CsvPack.import(
      'cpi',                    ## Annual Consumer Price Index (CPI)
      'gdp',                    ## Country, Regional and World GDP (Gross Domestic Product)
    )

    assert true  # if we get here - test success
  end

end # class TestImport
