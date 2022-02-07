# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_countries.rb


require 'helper'

class TestCountries < MiniTest::Test

  def test_country_list
    pack = CsvPack::Pack.new( './pack/country-list/datapackage.json' )

    meta = pack.meta
    puts "name: #{meta.name}"
    puts "title: #{meta.title}"
    puts "license: #{meta.license}"

    pp pack.tables

    ## pak.table.each do |row|
    ##  pp row
    ## end

    puts pack.table.dump_schema

    # database setup 'n' config
    ActiveRecord::Base.establish_connection( adapter:  'sqlite3',
                                             database: ':memory:' )
    ActiveRecord::Base.logger = Logger.new( STDOUT )

    pack.table.up!
    pack.table.import!

    pp pack.table.ar_clazz

    assert true  # if we get here - test success
  end

end # class TestCountries
