# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_record_auto.rb


require 'helper'

class TestRecordAuto < MiniTest::Test


def test_read
  beers = CsvRecord.read( "#{CsvRecord.test_data_dir}/beer.csv" ).to_a
  pp beers

  assert_equal 6, beers.size
  assert_equal 'Andechser Klosterbrauerei', beers[0].brewery
  assert_equal 'Andechs',                   beers[0].city
  assert_equal 'Doppelbock Dunkel',         beers[0].name
  assert_equal '7%',                        beers[0].abv
end


def test_foreach
  CsvRecord.foreach( "#{CsvRecord.test_data_dir}/beer.csv" ) do |rec|
    pp rec
    puts "#{rec.name} (#{rec.abv}%) by #{rec.brewery}, #{rec.city}"
  end

  assert true
end

end # class TestRecordAuto
