# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_downloader.rb


require 'helper'

class TestDownloader < MiniTest::Test

  def test_download

    names = [
      'country-list',
      'country-codes',
      'language-codes',
      'cpi',                    ## Annual Consumer Price Index (CPI)
      'gdp',                    ## Country, Regional and World GDP (Gross Domestic Product)
      's-and-p-500-companies',  ## S&P 500 Companies with Financial Information
      'un-locode',              ## UN-LOCODE Codelist  - note: incl. country-codes.csv
    ]

    dl = CsvPack::Downloader.new
    names.each do |name|
      dl.fetch( name )
    end

    assert true  # if we get here - test success
  end

end # class TestDownloader
