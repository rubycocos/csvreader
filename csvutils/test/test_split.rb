# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_split.rb


require 'helper'

class TestSplit < MiniTest::Test

  def test_eng
    path = "#{CsvUtils.test_data_dir}/eng-england/2017-18/E0.csv"
    columns = [ 'HomeTeam' ]
    CsvUtils.split( path, *columns ) do |values, chunk|
      pp values
      pp chunk
    end
  end


  def test_de
    path = "#{CsvUtils.test_data_dir}/de-deutschland/bundesliga.csv"
    columns = ['Saison', 'Spieltag' ]
    CsvUtils.split( path, *columns, sep: ';' ) do |values, chunk|
      pp values
      pp chunk
    end
  end

end # class TestSplit
