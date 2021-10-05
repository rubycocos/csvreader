# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_cut.rb


require 'helper'

class TestCut < MiniTest::Test

  def test_eng
    path = "#{CsvUtils.test_data_dir}/eng-england/2017-18/E0.csv"
    columns = [ 'HomeTeam', 'FTHG', 'FTAG', 'AwayTeam', 'Date' ]
    CsvUtils.cut( path, *columns, output: './tmp/cut_test_eng.csv' )
  end

  def test_at
    path = "#{CsvUtils.test_data_dir}/at-austria/AUT.csv"
    columns = [ 'Home', 'HG', 'AG', 'Away', 'Date', 'Time' ]
    CsvUtils.cut( path, *columns, output: './tmp/cut_test_at.csv' )
  end

  def test_de
    path = "#{CsvUtils.test_data_dir}/de-deutschland/bundesliga.csv"
    columns = ['Saison', 'Spieltag',
               'Heim', 'Ergebnis', 'Gast', 'Datum', 'Uhrzeit' ]
    CsvUtils.cut( path, *columns, sep: ';', output: './tmp/cut_test_de.csv' )
  end

end # class TestHead
