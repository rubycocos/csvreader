# encoding: utf-8

class CsvReader

class ParserTab

def parse( data, limit: nil, &block )

  ## note: input: required each_line (string or io/file for example)
  input = data   ## assume it's a string or io/file handle

  if block_given?
    parse_lines( input, limit: limit, &block )
  else
    records = []

    parse_lines( input, limit: limit ) do |record|
      records << record
    end

    records
  end
end ## method parse



private

def parse_lines( input, limit: nil, &block )

  records = 0    ## keep track of records

  ##
  ## note: each line only works with \n (windows) or \r\n (unix)
  ##   will NOT work with \r (old mac, any others?) only!!!!
  input.each_line do |line|

    ## puts "line:"
    ## pp line

    ##  note: chomp('') if is an empty string,
    ##    it will remove all trailing newlines from the string.
    ##    use line.sub(/[\n\r]*$/, '') or similar instead - why? why not?
    line = line.chomp( '' )
    ## pp line

    # note: trailing empty fields get (auto-)trimmed by split !!!!!!!
    values = line.split( "\t" )
    ## pp values

    ## note: requires block - enforce? how? why? why not?
    block.call( values )
    records += 1
    ## set limit to 1 for processing "single" line (that is, get one record)
    break if limit && limit >= records
  end
end # method parse_lines


end # class ParserTab
end # class CsvReader
