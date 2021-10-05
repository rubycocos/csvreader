# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_head.rb


require 'helper'

class TestHead < MiniTest::Test

  def test_eng
    path = "#{CsvUtils.test_data_dir}/eng-england/2017-18/E0.csv"

    CsvUtils.head( path )
  end

  def test_at
    path = "#{CsvUtils.test_data_dir}/at-austria/AUT.csv"

    CsvUtils.head( path )
  end

  def test_de
    path = "#{CsvUtils.test_data_dir}/de-deutschland/bundesliga.csv"

    CsvUtils.head( path, sep: ';' )
  end

end # class TestHead
