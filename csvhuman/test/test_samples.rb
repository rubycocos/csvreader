# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_samples.rb


require 'helper'

class TestSamples < MiniTest::Test


def test_sample1
  recs = CsvHuman.read( "#{CsvHuman.test_data_dir}/sample1.csv" )
  ## pp recs
  assert_equal [{"loc+name"=>"Camp A", "loc+code"=>"01000001", "affected"=>2000},
                {"loc+name"=>"Camp B", "loc+code"=>"01000002", "affected"=>750},
                {"loc+name"=>"Camp C", "loc+code"=>"01000003", "affected"=>1920}], recs
end

def test_sample2
  recs = CsvHuman.read( "#{CsvHuman.test_data_dir}/sample2.csv" )
  ## pp recs
  assert_equal [{"event+id"=>1,
                 "affected+killed"=>1,
                 "region"=>"Mediterranean",
                 "meta+reliability+source"=>"Verified",
                 "date+reported"=>Date.new( 2015, 11, 5 ),
                 "geo+lat"=>36.8915,
                 "geo+lon"=>27.2877},
                {"event+id"=>3,
                 "affected+killed"=>1,
                 "region"=>"Central America incl. Mexico",
                 "meta+reliability+source"=>"Partially Verified",
                 "date+reported"=>Date.new( 2015, 11, 3 ),
                 "geo+lat"=>15.9564,
                 "geo+lon"=>-93.663099}], recs
end

def test_sample3
  recs = CsvHuman.read( "#{CsvHuman.test_data_dir}/sample3.csv" )
  ## pp recs
  assert_equal [{"loc+code"=>["020503", nil, nil]},
                {"loc+code"=>["060107", "060108", nil]},
                {"loc+code"=>["173219", nil, nil]},
                {"loc+code"=>["530012", nil, nil]},
                {"loc+code"=>["530013", "530015", "279333"]}], recs
end

def test_sample4
  recs = CsvHuman.read( "#{CsvHuman.test_data_dir}/sample4.csv" )
  ## pp recs
  assert_equal [{"adm1+name"=>"Coast District",    "affected+label"=>[0, 30, 100, 250]},
                {"adm1+name"=>"Mountain District", "affected+label"=>[15, 75, 30, 45]}], recs
end


end # class TestSamples
