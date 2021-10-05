# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_record.rb


require 'helper'

class TestRecord < MiniTest::Test

  def test_class_style1
     clazz1 = CsvRecord.define do
       field :brewery, :string   # fix: do NOT use 'Brewery' - name SHOULD be a valid variable name
       field :city,    :string
       field :name     ## default type is :string
       field :abv,     Float    ## allow type specified as class
     end
     pp clazz1
     pp clazz1.fields

     assert true  ## assume ok if we get here
  end

  Beer = CsvRecord.define do
     string :brewery   # fix: do NOT use 'Brewery' - name SHOULD be a valid variable name
     string :city
     string :name
     float  :abv
  end

  class BeerClassic < CsvRecord::Base
    field :brewery
    field :city
    field :name
    field :abv, Float
  end


  def test_class_style2
    clazz2 = CsvRecord.define do
       string :brewery   # fix: do NOT use 'Brewery' - name SHOULD be a valid variable name
       string :city
       string :name
       float  :abv
    end
    pp clazz2
    pp clazz2.class.name
    pp clazz2.fields

    txt  = File.open( "#{CsvRecord.test_data_dir}/beer.csv", 'r:utf-8' ).read
    data = CsvReader.parse( txt )
    pp data
    pp data.to_a   ## note: includes header (first row with field names)

    puts "== parse( data ).to_a:"
    pp clazz2.parse( data ).to_a
    pp Beer.parse( data ).to_a

    puts "== parse( data ).each:"
    ## loop over records
    clazz2.parse( data ).each do |rec|
      puts "#{rec.name} (#{rec.abv}%) by #{rec.brewery}, #{rec.city}"
    end

    puts "== parse( txt ).to_a:"
    pp Beer.parse( txt ).to_a

    pp clazz2.class.name
    pp clazz2.class.name
    pp Beer.class.name

    clazz2b = CsvRecord.define do |rec|   ## try "yield"-style dsl with block.arity == 1
       rec.string :brewery
       rec.string :city
       rec.string :name
       rec.float  :abv
    end
    pp clazz2b
    pp clazz2b.class.name
    pp clazz2b.fields

    assert true  ## assume ok if we get here
  end


  def test_read
    puts "== read( data ).to_a:"
    beers = Beer.read( "#{CsvRecord.test_data_dir}/beer.csv" ).to_a
    puts "#{beers.size} beers:"
    pp beers

    pp Beer.fields

    assert true  ## assume ok if we get here
  end


  def test_foreach
    puts "== foreach:"
    Beer.foreach( "#{CsvRecord.test_data_dir}/beer.csv" ) do |rec|
      puts "#{rec.name} (#{rec.abv}%) by #{rec.brewery}, #{rec.city}"
    end

    assert true  ## assume ok if we get here
  end


  def test_parse_array_or_arrays
    data=[
      ['Brewery','City','Name','Abv'],
      ['Andechser Klosterbrauerei','Andechs','Doppelbock Dunkel','7%'],
      ['Augustiner Bräu München','München','Edelstoff','5.6%'],
      ['Bayerische Staatsbrauerei Weihenstephan','Freising','Hefe Weissbier','5.4%'],
      ['Brauerei Spezial','Bamberg','Rauchbier Märzen','5.1%'],
      ['Hacker-Pschorr Bräu','München','Münchner Dunkel','5.0%'],
      ['Staatliches Hofbräuhaus München','München','Hofbräu Oktoberfestbier','6.3%']]

    beers = Beer.parse( data ).to_a
    puts "#{beers.size} beers:"
    pp beers

    assert true  ## assume ok if we get here
  end


  def test_classic
    puts "== read( data ).to_a:"
    beers = BeerClassic.read( "#{CsvRecord.test_data_dir}/beer.csv" ).to_a
    puts "#{beers.size} beers:"
    pp beers

    pp BeerClassic.fields
    pp BeerClassic.field_names
    pp BeerClassic.columns       ## try fields alias
    pp BeerClassic.column_names  ## try field_names alias

    assert_equal [:brewery, :city, :name, :abv], BeerClassic.field_names
    assert_equal [String, String, String, Float], BeerClassic.field_types


    assert_equal ['Andechser Klosterbrauerei',
                  'Andechs',
                  'Doppelbock Dunkel',
                  7.0], beers[0].values     ## typed values

    beer_hash = { brewery: 'Andechser Klosterbrauerei',
                  city:    'Andechs',
                  name:    'Doppelbock Dunkel',
                  abv:     7.0 }
    assert_equal beer_hash, beers[0].to_h     ## typed name/value pairs (hash)

    assert_equal  ['Andechser Klosterbrauerei',
                  'Andechs',
                  'Doppelbock Dunkel',
                  '7.0'], beers[0].to_csv  ## try to_csv all string values


    beer = BeerClassic.new
    pp beer
    beer.update( abv: 12.7 )
    beer.update( brewery: 'Andechser Klosterbrauerei',
                 city:   'Andechs',
                 name:   'Doppelbock Dunkel' )
    pp beer

    assert_equal 12.7, beer.abv
    assert_equal 'Andechser Klosterbrauerei', beer.brewery
    assert_equal 'Andechs', beer.city
    assert_equal 'Doppelbock Dunkel', beer.name
  end


  def test_new
    beer = Beer.new
    pp beer
    beer.update( abv: 12.7 )
    beer.update( brewery: 'Andechser Klosterbrauerei',
                 city:   'Andechs',
                 name:   'Doppelbock Dunkel' )
    pp beer

    assert_equal 12.7, beer.abv
    assert_equal 'Andechser Klosterbrauerei', beer.brewery
    assert_equal 'Andechs', beer.city
    assert_equal 'Doppelbock Dunkel', beer.name


    pp beer.abv
    pp beer.abv = 12.7
    pp beer.abv
    assert_equal 12.7, beer.abv

    pp beer.parse_abv( '12.8%' )   ## (auto-)converts/typecasts string to specified type (e.g. float)
    assert_equal 12.8, beer.abv

    pp beer.name
    pp beer.name = 'Doppelbock Dunkel'
    pp beer.name
    assert_equal 'Doppelbock Dunkel', beer.name


    beer2 = Beer.new( brewery: 'Andechser Klosterbrauerei',
                      city:   'Andechs',
                      name:   'Doppelbock Dunkel' )
    pp beer2

    assert_nil   beer2.abv
    assert_equal 'Andechser Klosterbrauerei', beer2.brewery
    assert_equal 'Andechs', beer2.city
    assert_equal 'Doppelbock Dunkel', beer2.name
  end

  def test_parse
    values = ['Andechser Klosterbrauerei',
              'Andechs',
              'Doppelbock Dunkel',
              '7.0']

    beer = Beer.new
    beer.parse( values )

    assert_equal values,         beer.to_csv
    assert_equal values[0],      beer.brewery
    assert_equal values[1],      beer.city
    assert_equal values[2],      beer.name
    assert_equal values[3].to_f, beer.abv

    assert_equal values[0],      beer[0]
    assert_equal values[1],      beer[1]
    assert_equal values[2],      beer[2]
    assert_equal values[3].to_f, beer[3]

    assert_equal values[0],      beer.values[0]
    assert_equal values[1],      beer.values[1]
    assert_equal values[2],      beer.values[2]
    assert_equal values[3].to_f, beer.values[3]

    assert_equal values[0],      beer[:brewery]
    assert_equal values[1],      beer[:city]
    assert_equal values[2],      beer[:name]
    assert_equal values[3].to_f, beer[:abv]

    assert_equal values[0],      beer['Brewery']
    assert_equal values[1],      beer['City']
    assert_equal values[2],      beer['Name']
    assert_equal values[3].to_f, beer['Abv']
  end

end # class TestRecord
