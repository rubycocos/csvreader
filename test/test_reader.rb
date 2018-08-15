# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader.rb


require 'helper'

class TestReader < MiniTest::Test

def test_read
  puts "== read: beer.csv:"
  table = CsvReader.read( "#{CsvReader.test_data_dir}/beer.csv" )   ## returns CSV::Table

  pp table.class.name
  pp table
  pp table.to_a   ## note: includes header (first row with column names)

  table.each do |row|   ## note: will skip (NOT include) header row!!
    pp row
  end
  puts "  #{table.size} rows"  ## note: again will skip (NOT include) header row in count!!!
  assert_equal 6, table.size
end

def test_read_header_false
  puts "== read (headers: false): beer.csv:"
  data = CsvReader.read( "#{CsvReader.test_data_dir}/beer.csv", headers: false )

  pp data.class.name
  pp data

  data.each do |row|
    pp row
  end
  puts "  #{data.size} rows"
  assert_equal 7, data.size   ## note: include header row in count
end


def test_read11
  puts "== read: beer11.csv:"
  table = CsvReader.read( "#{CsvReader.test_data_dir}/beer11.csv" )
  pp table
  pp table.to_a   ## note: includes header (first row with column names)

  assert true
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
  puts "== foreach: beer.csv:"
  CsvReader.foreach( "#{CsvReader.test_data_dir}/beer.csv" ) do |row|
    pp row
    pp row.fields
  end
  assert true
end

def test_foreach11
  puts "== foreach: beer11.csv:"
  CsvReader.foreach( "#{CsvReader.test_data_dir}/beer11.csv" ) do |row|
    pp row
    pp row.fields
  end
  assert true
end

def test_foreach_header_false
  puts "== foreach (headers: false): beer11.csv:"
  CsvReader.foreach( "#{CsvReader.test_data_dir}/beer11.csv", headers: false ) do |row|
    pp row      ## note: is Array (no .fields available!!!!!)
  end
  assert true
end

end # class TestReader
