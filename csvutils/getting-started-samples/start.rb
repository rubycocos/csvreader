###
#  ruby script (data work flow) getting started sample from the csvutils readme
#    see https://github.com/csv11/csvutils
#

require 'csvutils'


CsvUtils.head( 'ENG.csv' )
# same as:
#  $ csvhead ENG.csv

CsvUtils.header( 'ENG.csv' )
# same as:
#  $ csvheader ENG.csv

CsvUtils.stat( 'ENG.csv', 'Team1', 'Team2' )
# same as:
#  $ csvstat -c Team1,Team2 ENG.csv


CsvUtils.stat( 'AUT.csv', 'Season' )
# same as:
#  $ csvstat -c Season AUT.csv


CsvUtils.split( 'AUT.csv', 'Season' )
# same as:
#  $ csvsplit -c Season AUT.csv

CsvUtils.cut( 'AUT_2016-2017.csv', 'Date', 'Team1', 'Team2', 'FT1', 'FT2' )
# same as:
#  $ csvcut -c Date,Team1,Team2,FT1,FT2 AUT_2016-2017.csv
