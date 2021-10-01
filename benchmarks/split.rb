# encoding: utf-8

def read_csv( path, sep: ',' )
  recs = []
  File.open( path, 'r:utf-8' ) do |f|
     f.each_line do |line|
       line   = line.chomp( '' )    ## fix: use line.chomp!  inplace - why? why not?
       values = line.split( sep )
       recs << values
     end
  end
  recs
end


def read_tab( path )    read_csv( path, sep: "\t" ); end

## todo: add converter for read_table - why, why not??
##   translate interpunct back to space
##    values = values.map { |value| value.tr( '•', ' ' ) }
def read_table( path )  read_csv( path, sep: /[ \t]+/ ); end





def read_faster_csv( path, sep: ',', converter: nil )
  recs = []
  File.open( path, 'r:utf-8' ) do |f|
     f.each_line do |line|
       ##  note: chomp('') if is an empty string,
       line   = line.chomp( '' )    ## fix: use line.chomp!  inplace - why? why not?
       values = line.split( sep )

       values = values.map { |v| converter.call(v) }    if converter

       recs << values
     end
  end
  recs
end



if __FILE__ == $0

require 'pp'

data = read_csv( './datasets/finance/MSFT.csv' )
pp data
date = read_tab( './datasets/finance/o/MSFT.tab' )
pp data
data = read_table( './datasets/finance/o/MSFT.txt' )
pp data[0..2]


end
