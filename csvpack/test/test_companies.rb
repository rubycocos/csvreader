# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_companies.rb


require 'helper'

class TestCompanies < MiniTest::Test

  def test_s_and_p_500_companies

    pack = CsvPack::Pack.new( './pack/s-and-p-500-companies/datapackage.json' )

    meta = pack.meta
    puts "name: #{meta.name}"
    puts "title: #{meta.title}"
    puts "license: #{meta.license}"

    pp pack.tables
    pp pack.table[0]['Symbol']
    pp pack.table[495]['Symbol']

    ## pak.table.each do |row|
    ##  pp row
    ## end

    puts pack.tables[0].dump_schema

    # database setup 'n' config
    ActiveRecord::Base.establish_connection( adapter:  'sqlite3',
                                             database: ':memory:' )
    ActiveRecord::Base.logger = Logger.new( STDOUT )

    pack.table.up!
    pack.table.import!

    ## pack.tables[0].up!
    ## pack.tables[0].import!


    pp pack.table.ar_clazz


    company = pack.table.ar_clazz

    puts "Company:"
    pp company.count
    pp company.first
    pp company.find_by!( symbol: 'MMM' )
    pp company.find_by!( name: '3M Company' )
    pp company.where( sector: 'Industrials' ).count
    pp company.where( sector: 'Industrials' ).all


    ### todo: try a join w/ belongs_to ??

    assert true  # if we get here - test success
  end

end # class TestCompanies
