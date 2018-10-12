
##
## add parser for new CSV <3 JSON format

require 'pp'
require 'json'
require 'stringio'


  class CsvJsonParser

   include Enumerable

    def initialize( data )
       if data.is_a?( String )
          @input = data   # note: just needs each for each_line
      else  ## assume io
          @input = data
      end
    end

    def each( &block )
      @input.each_line do |line|
        puts "line:"
        pp line

        ##  note: chomp('') if is an empty string,
        ##    it will remove all trailing newlines from the string.
        ##    use line.sub(/[\n\r]*$/, '') or similar instead - why? why not?
        line = line.chomp( '' )
        pp line

        if line.empty?             ## skip blank lines
          puts "skip blank line"
          next
        end

        if line.start_with?( "#" )  ## skip comment lines
          puts "skip comment line"
          next
        end

        ## note: auto-wrap in array e.g. with []
        json = JSON.parse( "[#{line}]" )
        pp json
        block.call( json )
      end
    end
  end # class CsvJsonParser



csv = CsvJsonParser.new( <<TXT )
# hello world

1,"John","12 Totem Rd. Aspen",true
2,"Bob",null,false
3,"Sue","Bigsby, 345 Carnival, WA 23009",false
TXT


table = csv.to_a
puts
puts "data:"
pp table
