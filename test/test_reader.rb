# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader.rb


require 'helper'

class TestReader < MiniTest::Test

def setup
  CsvReader::Parser.logger.level = :debug   ## turn on "global" logging - move to helper - why? why not?
end


def test_read
  puts "== read: beer.csv:"
  rows = CsvReader.read( "#{CsvReader.test_data_dir}/beer.csv" )
  pp rows

  rows.each do |row|
    pp row
  end
  puts "  #{rows.size} rows"
  assert_equal 7, rows.size   ## note: include header row in count
end



def test_parse_line
  puts "== parse_line:"
  row = CsvReader.parse_line( <<TXT )
Augustiner Bräu München,                 München,  Edelstoff,      5.6%
Bayerische Staatsbrauerei Weihenstephan, Freising, Hefe Weissbier, 5.4%
TXT

  pp row
  assert_equal ['Augustiner Bräu München', 'München', 'Edelstoff', '5.6%'], row
end

def test_parse_line11
  puts "== parse_line:"
  row = CsvReader.parse_line( <<TXT )
#######
#  try with some comments
#   and blank lines even before header

Augustiner Bräu München,                 München,   Edelstoff,      5.6%
Bayerische Staatsbrauerei Weihenstephan, Freising,  Hefe Weissbier, 5.4%
TXT

  pp row
  assert_equal ['Augustiner Bräu München', 'München', 'Edelstoff', '5.6%'], row
end

def test_header
  puts "== header: beer.csv:"
  header = CsvReader.header( "#{CsvReader.test_data_dir}/beer.csv" )
  pp header
  assert_equal ['Brewery','City','Name','Abv'], header
end

def test_header11
  puts "== header: beer11.csv:"
  header = CsvReader.header( "#{CsvReader.test_data_dir}/beer11.csv" )
  pp header
  assert_equal ['Brewery','City','Name','Abv'], header
end



def test_foreach
  puts "== foreach: beer11.csv:"
  CsvReader.foreach( "#{CsvReader.test_data_dir}/beer11.csv" ) do |row|
    pp row
  end
  assert true
end

end # class TestReader
