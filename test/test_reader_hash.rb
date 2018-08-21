# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader_hash.rb


require 'helper'

class TestHashReader < MiniTest::Test


def test_read
  puts "== read (hash): beer.csv:"
  rows = CsvHashReader.read( "#{CsvReader.test_data_dir}/beer.csv" )
  pp rows
  pp rows.to_a

  rows.each do |row|   ## note: will skip (NOT include) header row!!
    pp row
  end
  puts "  #{rows.size} rows"  ## note: again will skip (NOT include) header row in count!!!
  assert_equal 6, rows.size
end

def test_read11
  puts "== read (hash): beer11.csv:"
  rows = CsvHashReader.read( "#{CsvReader.test_data_dir}/beer11.csv" )
  pp rows
  pp rows.to_a   ## note: includes header (first row with column names)

  assert true
end


def test_foreach
  puts "== foreach (hash): beer.csv:"
  CsvHashReader.foreach( "#{CsvReader.test_data_dir}/beer.csv" ) do |row|
    pp row
  end
  assert true
end

def test_foreach11
  puts "== foreach (hash): beer11.csv:"
  CsvHashReader.foreach( "#{CsvReader.test_data_dir}/beer11.csv" ) do |row|
    pp row
  end
  assert true
end

end # class TestHashReader
