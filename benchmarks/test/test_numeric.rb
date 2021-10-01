# encoding: utf-8

###
# note: use
#   $ ruby ./test/test_numeric.rb
#  to run test


require 'minitest/autorun'

require_relative '../helper'    ## note: adds LenientCSV.read




class TestNumeric  < MiniTest::Test

def weather_recs
 ## note: for now do NOT include header line
 ##  ["year", "month", "day", "hour", "minute",
 ##   "Temperature",
 ##   "Precipitation - Tipping Bucket",
 ##   "Precipitation - Weighing",
 ##   "Solar - Incoming",
 ##   "Solar - Outgoing",
 ##   "Wind Speed - Average 4.4",
 ##   "Wind Speed - Gust 4.4",
 ##   "Wind Speed - Average 2.0",
 ##   "Wind Speed - Gust 2.0",
 ##   "Wind Direction",
 ##   "RH",
 ##   "Pressure",
 ##   "Soil Moisture - 5 cm",
 ##   "Soil Moisture - 10 cm",
 ##   "Soil Moisture - 20 cm"
 ##  ]

 [[2017,   1,   1,   0,   0,   -27.95667,   0.0,   0.0,   1.0,   1.0,   0.0,   0.0,   0.0,   0.0,   329.0,   80.50667,   103.26868,   -9999.90039,   -9999.90039,   0.285,   4.11733,   -30.30333],
  [2017,   1,   1,   0,   15,   -27.95667,   0.0,   0.0,   1.0,   1.0,   0.0,   0.0,   0.0,   0.0,   329.0,   80.50667,   103.26868,   -9999.90039,   -9999.90039,   0.285,   4.11733,   -30.30333],
  [2017,   1,   1,   0,   30,   -28.27733,   0.0,   0.0,   1.0,   1.0,   0.0,   0.0,   0.0,   0.0,   329.0,   80.54666,   103.25867,   -9999.90039,   -9999.90039,   0.285,   4.11667,   -30.612,],
  [2017,   1,   1,   0,   45,   -28.40533,   0.0,   0.0,   1.0,   1.0,   0.0,   0.0,   0.0,   0.0,   329.0,   80.54666,   103.26067,   -9999.90039,   -9999.90039,   0.285,   4.11333,   -30.73867],
  [2017,   1,   1,   1,   0,   -28.57334,   0.0,   0.0,   1.0,   1.0,   0.0,   0.0,   0.0,   0.0,   329.0,   80.64666,   103.26268,   -9999.90039,   -9999.90039,   0.285,   4.11267,   -30.88934]]
end



def test_read_csv
  options = { converter: ->(v) { Float(v) rescue v } }
  recs = read_faster_csv( "#{data_dir}/weather/Hobo_15minute_2017.csv", options )

  assert_equal 300, recs.size
  assert_equal weather_recs, recs[1..5]
end

def test_read_table
  options = { sep: /[ \t]+/, converter: ->(v) { Float(v) rescue v } }
  recs = read_faster_csv( "#{data_dir}/weather/o/Hobo_15minute_2017.txt", options )

  ## pp recs[0]   ## note: skip header row
  assert_equal 300, recs.size
  assert_equal weather_recs, recs[1..5]
end



def test_csv_std
  options = { :converters => :all }
  recs = CSV.read( "#{data_dir}/weather/Hobo_15minute_2017.csv", options )

  ## pp recs[1..5]  ## note: skip header row
  assert_equal 300, recs.size
  assert_equal weather_recs, recs[1..5]
end


def test_reader_csv
  options = { :converters => :all }
  recs = CsvReader.read( "#{data_dir}/weather/Hobo_15minute_2017.csv", options )

  assert_equal 300, recs.size
  assert_equal weather_recs, recs[1..5]
end

def test_reader_numeric
  recs = CsvReader.numeric.read( "#{data_dir}/weather/Hobo_15minute_2017.csv" )

  ## note: will return all numbers as floats!!
  ##   e.g.      [2017.0,  1.0,  1.0,  0.0, ...]
  ##    and NOT  [2017,    1,    1,    0,   ...]

  ## pp recs[1..5]  ## note: skip header row
  assert_equal 300, recs.size
  assert_equal weather_recs, recs[1..5]
end

def test_reader_json
  recs = CsvReader.json.read( "#{data_dir}/weather/o/Hobo_15minute_2017.json.csv" )

  assert_equal 300, recs.size
  assert_equal weather_recs, recs[1..5]
end

def test_reader_yaml
  recs = CsvReader.yaml.read( "#{data_dir}/weather/Hobo_15minute_2017.csv" )

  ## pp recs[0]   ## note: skip header row
  assert_equal 300, recs.size
  assert_equal weather_recs, recs[1..5]
end

end # class TestNumeric
