###
#  ruby script (data work flow) getting started sample from the csvpack readme
#    see https://github.com/csvreader/csvpack
#

require 'csvpack'


CsvPack.import(
  's-and-p-500-companies',
  'gdb'
)





pack = CsvPack::Pack.new( './pack/s-and-p-500-companies' )

Constituent = pack.table.ar_clazz


pp Constituent.count
# SELECT COUNT(*) FROM "constituents"
# => 496


pp Constituent.first
# SELECT  "constituents".* FROM "constituents" ORDER BY "constituents"."id" ASC LIMIT 1
# => #<Constituent:0x9f8cb78
#         id:     1,
#         symbol: "MMM",
#         name:   "3M Company",
#         sector: "Industrials">


pp Constituent.find_by!( symbol: 'MMM' )
# SELECT  "constituents".*
#         FROM "constituents"
#         WHERE "constituents"."symbol" = "MMM"
#         LIMIT 1
# => #<Constituent:0x9f8cb78
#         id:     1,
#         symbol: "MMM",
#         name:   "3M Company",
#         sector: "Industrials">


pp Constituent.find_by!( name: '3M Company' )
# SELECT  "constituents".*
#          FROM "constituents"
#          WHERE "constituents"."name" = "3M Company"
#          LIMIT 1
# => #<Constituent:0x9f8cb78
#         id:     1,
#         symbol: "MMM",
#         name:   "3M Company",
#         sector: "Industrials">


pp Constituent.where( sector: 'Industrials' ).count
# SELECT COUNT(*) FROM "constituents"
#         WHERE "constituents"."sector" = "Industrials"
# => 63


pp Constituent.where( sector: 'Industrials' ).all
# SELECT "constituents".*
#         FROM "constituents"
#         WHERE "constituents"."sector" = "Industrials"
# => [#<Constituent:0x9f8cb78
#          id:     1,
#          symbol: "MMM",
#          name:   "3M Company",
#          sector: "Industrials">,
#      #<Constituent:0xa2a4180
#          id:     8,
#          symbol: "ADT",
#          name:   "ADT Corp (The)",
#          sector: "Industrials">,...]



#####
#   From F.A.Q.


dl = CsvPack::Downloader.new
dl.fetch( 'language-codes' )
dl.fetch( 's-and-p-500-companies' )
dl.fetch( 'un-locode')



#######
#  New db connection - store to ./mine.db

ActiveRecord::Base.establish_connection( adapter:  'sqlite3',
                                         database: './mine.db' )

## import 1) "auto"-magic
CsvPack.import(
  's-and-p-500-companies'
)

## import 2) "by hand"
pack = CsvPack::Pack.new( './pack/gdb' )
pack.tables.each do |table|
  table.up!      # (auto-) add table  using SQL create_table via ActiveRecord migration
  table.import!  # import all records using SQL inserts
end
