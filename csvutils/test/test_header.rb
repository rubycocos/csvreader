# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_header.rb


require 'helper'

class TestHeader < MiniTest::Test


##
# Div,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HTHG,HTAG,HTR,
#   Referee,HS,AS,HST,AST,HF,AF,HC,AC,HY,AY,HR,AR,
#    B365H,B365D,B365A,BWH,BWD,BWA,IWH,IWD,IWA,LBH,LBD,LBA,PSH,PSD,PSA,
#    WHH,WHD,WHA,VCH,VCD,VCA,
#    Bb1X2,BbMxH,BbAvH,BbMxD,BbAvD,BbMxA,BbAvA,BbOU,BbMx>2.5,BbAv>2.5,BbMx<2.5,BbAv<2.5,
#    BbAH,BbAHh,BbMxAHH,BbAvAHH,BbMxAHA,BbAvAHA,PSCH,PSCD,PSCA
  def test_eng
    path = "#{CsvUtils.test_data_dir}/eng-england/2017-18/E0.csv"

    headers = CsvUtils.header( path )
    pp headers

    assert_equal ['Date','HomeTeam','AwayTeam','FTHG','FTAG','HTHG','HTAG'], headers
  end

###
# Country,League,Season,Date,Time,Home,Away,HG,AG,
#  Res,PH,PD,PA,MaxH,MaxD,MaxA,AvgH,AvgD,AvgA
  def test_at
    path = "#{CsvUtils.test_data_dir}/at-austria/AUT.csv"

    headers =  CsvUtils.header( path )
    pp headers

    assert_equal ['Season','Date','Time','Home','Away','HG','AG'], headers
  end

  def test_de
    path = "#{CsvUtils.test_data_dir}/de-deutschland/bundesliga.csv"

    headers =  CsvUtils.header( path, sep: ';' )
    pp headers

    assert_equal ['Spielzeit','Saison','Spieltag','Datum','Uhrzeit','Heim','Gast','Ergebnis','Halbzeit'], headers
  end

end # class TestHeader
