# encoding: utf-8

class CsvReader

class ParserTab

def parse( data, **kwargs, &block )

  ## note: input: required each_line (string or io/file for example)
  ## note: kwargs NOT used for now (but required for "protocol/interface" by other parsers)

  input = data   ## assume it's a string or io/file handle

  if block_given?
    parse_lines( input, &block )
  else
    records = []

    parse_lines( input ) do |record|
      records << record
    end

    records
  end
end ## method parse



private

def parse_lines( input, &block )

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
    #  Solution!!  change split( "\t" ) to split( "\t", -1 ) 
    #   However, if this argument is negative (any negative number), 
    #   then there will be no limit on the number of elements in the output array 
    #   and any trailing delimiters will appear as zero-length strings at the end of the array    
    
    values = line.split( "\t", -1 )
    ## pp values

    ## note: requires block - enforce? how? why? why not?
    block.call( values )
  end
end # method parse_lines


end # class ParserTab
end # class CsvReader
