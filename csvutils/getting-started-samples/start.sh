###
#  command line shell script getting started sample from the csvutils readme
#    see https://github.com/csv11/csvutils
#

##########################################
## try help output of tools
csvhead -h          # or
csvhead --help

csvheader -h
csvstat -h
csvsplit -h
csvcut -h

####################################################
# Working with Comma-Separated Values (CSV) Datafile Examples

csvhead ENG.csv
csvheader ENG.csv
csvstat -c Team1,Team2 ENG.csv

#####################################################
# Split & Cut - Split One Datafile into Many or Cut / Reorder Columns

csvstat -c Season AUT.csv
csvsplit -c Season AUT.csv
csvcut -c Date,Team1,Team2,FT1,FT2 AUT_2016-2017.csv
csvhead AUT_2016-2017.csv
