# encoding: utf-8


class CsvReader

class ParserYaml

def parse( data, **kwargs, &block )
  ## note: kwargs NOT used for now (but required for "protocol/interface" by other parsers)

  ## note: input: required each_line (string or io/file for example)
  ## assume data is a string or io/file handle
  csv = CsvYaml.new( data )

  if block_given?
    csv.each( &block )
  else
    csv.to_a
  end
end ## method parse


end # class ParserYaml
end # class CsvReader
