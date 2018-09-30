# encoding: utf-8

class CsvHashReader

  def initialize( parser )
    @parser = parser
  end

  DEFAULT = new( CsvReader::Parser::DEFAULT )
  RFC4180 = new( CsvReader::Parser::RFC4180 )

  def self.default()  DEFAULT; end    ## alternative alias for DEFAULT
  def self.rfc4180()  RFC4180; end    ## alternative alias for RFC4180


  def self.parse( data, sep: nil, headers: nil )
    DEFAULT.parse( data, sep: sep, headers: headers )
  end

  def self.read( path, sep: nil, headers: nil )
    DEFAULT.read( path, sep: sep, headers: headers )
  end

  def self.foreach( path, sep: nil, headers: nil, &block )
    DEFAULT.foreach( path,sep: sep, headers: headers, &block )
  end



#############################
## all "high-level" reader methods
##

def parse( data, sep: nil, headers: nil, &block )
  if block_given?
    parse_lines( data, sep: sep, headers: headers, &block )
  else
    records = []
    parse_lines( data, sep: sep, headers: headers ) do |record|
      records << record
    end
    records
  end
end


def read( path, sep: nil, headers: nil )
  txt = File.open( path, 'r:bom|utf-8' ).read
  parse( txt, sep: sep, headers: headers )
end


def foreach( path, sep: nil, headers: nil, &block )
  File.open( path, 'r:bom|utf-8' ) do |file|
    parse_lines( file, sep: sep, headers: headers, &block )
  end
end


private

####################
## parse_lines helper method to keep in one (central) place only (for easy editing/changing)
##   - builds key/value pairs

def parse_lines( data, sep: nil, headers: nil, &block)
  ## pass in headers as array e.g. ['A', 'B', 'C']
  names = headers ? headers : nil

  kwargs = {
    ##  converters: converters  ## todo: add converters
  }
  kwargs[:sep] = sep    unless sep.nil?   ## note: only add separator if present/defined (not nil)

  @parser.parse( data, kwargs ) do |values|     # sep: sep
    if names.nil?
      names = values   ## store header row / a.k.a. field/column names
    else
      record = names.zip( values ).to_h    ## todo/fix: check for more values than names/headers!!!
      block.call( record )
    end
  end
end

end # class CsvHashReader
