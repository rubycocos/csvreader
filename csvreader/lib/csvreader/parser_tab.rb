
class CsvReader

class ParserTab

def parse( data, **kwargs, &block )
  ## note: kwargs NOT used for now (but required for "protocol/interface" by other parsers)

  ## note: input: required each_line (string or io/file for example)
  ## assume data is a string or io/file handle
  tab = TabReader.new( data )

  if block_given?
    tab.each( &block )
  else
    tab.to_a
  end
end ## method parse


end # class ParserTab
end # class CsvReader
