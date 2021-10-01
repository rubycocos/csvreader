# encoding: utf-8


require 'benchmark'

require_relative 'helper'



## "raw" string reader benchmark - no type inference and data conversion

n = 1000
# n = 2


Benchmark.bm(15) do |x|
  x.report( 'std:' )            { n.times do CSV.read( "#{data_dir}/finance/MSFT.csv" ); end }

  x.report( 'split:' )          { n.times do read_csv( "#{data_dir}/finance/MSFT.csv" ); end }
  x.report( 'split(tab):' )     { n.times do read_tab( "#{data_dir}/finance/o/MSFT.tab" ); end }
  x.report( 'split(table)*:' )  { n.times do read_table( "#{data_dir}/finance/o/MSFT.tab" ); end }
  x.report( 'split(table):' )   { n.times do read_table( "#{data_dir}/finance/o/MSFT.txt" ); end }

  x.report( 'reader:' )         { n.times do CsvReader.read( "#{data_dir}/finance/MSFT.csv" ); end }
  x.report( 'reader(tab):' )    { n.times do CsvReader.tab.read( "#{data_dir}/finance/o/MSFT.tab" ); end }
  x.report( 'reader(table)*:' ) { n.times do CsvReader.table.read( "#{data_dir}/finance/o/MSFT.tab" ); end }
  x.report( 'reader(table):' )  { n.times do CsvReader.table.read( "#{data_dir}/finance/o/MSFT.txt" ); end }
  x.report( 'reader(json):' )   { n.times do CsvReader.json.read( "#{data_dir}/finance/o/MSFT.json.csv" ); end }
  x.report( 'reader(yaml):' )   { n.times do CsvReader.yaml.read( "#{data_dir}/finance/MSFT.csv" ); end }

  x.report( 'hippie:' )         { n.times do HippieCSV.read( "#{data_dir}/finance/MSFT.csv" ); end }
  x.report( 'wtf:' )            { n.times do WtfCSV.scan( "#{data_dir}/finance/MSFT.csv" );end }
  x.report( 'lenient:' )        { n.times do LenientCSV.read( "#{data_dir}/finance/MSFT.csv" ); end }
end



## numerics reader benchmark - all records numeric (limited type inference and data conversion)

n = 100
# n=2

Benchmark.bm(15) do |x|
  x.report( 'std:' ) { n.times do CSV.read( "#{data_dir}/weather/Hobo_15minute_2017.csv", { :converters => :all }); end }

  x.report( 'split:' )           { n.times do read_faster_csv( "#{data_dir}/weather/Hobo_15minute_2017.csv", { converter: ->(v) { Float(v) rescue v } }); end }
  x.report( 'split(table):' )    { n.times do read_faster_csv( "#{data_dir}/weather/o/Hobo_15minute_2017.txt", { sep: /[ \t]+/, converter: ->(v) { Float(v) rescue v }}); end }

  x.report( 'reader:' )          { n.times do CsvReader.read( "#{data_dir}/weather/Hobo_15minute_2017.csv", { :converters => :all }); end }
  x.report( 'reader(table):' )   { n.times do CsvReader.table.read( "#{data_dir}/weather/Hobo_15minute_2017.csv", { :converters => :all }); end }
  x.report( 'reader(numeric):' ) { n.times do CsvReader.numeric.read( "#{data_dir}/weather/Hobo_15minute_2017.csv" ); end }
  x.report( 'reader(json):' )    { n.times do CsvReader.json.read( "#{data_dir}/weather/o/Hobo_15minute_2017.json.csv" ); end }
  x.report( 'reader(yaml):' )    { n.times do CsvReader.yaml.read( "#{data_dir}/weather/Hobo_15minute_2017.csv" ); end }
end
