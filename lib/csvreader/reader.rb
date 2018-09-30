# encoding: utf-8



class CsvReader

  def initialize( parser )
    @parser = parser
  end

  DEFAULT = new( Parser::DEFAULT )
  RFC4180 = new( Parser::RFC4180 )
  EXCEL   = new( Parser::EXCEL )

  def self.default()  DEFAULT; end    ## alternative alias for DEFAULT
  def self.rfc4180()  RFC4180; end    ## alternative alias for RFC4180
  def self.excel()    EXCEL; end      ## alternative alias for EXCEL


  #####################
  ## convenience helpers defaulting to default csv dialect/format reader
  ##
  ##   CsvReader.parse_line is the same as
  ##     CsvReader::DEFAULT.parse_line or CsvReader.default.parse_line
  ##

  def self.parse( data, sep: nil,
                        converters: nil, &block )
     DEFAULT.parse( data, sep: sep, converters: converters, &block )
  end

  def self.parse_line( data, sep: nil,
                             converters: nil )
     DEFAULT.parse_line( data, sep: sep, converters: converters )
  end

  def self.read( path, sep: nil,
                       converters: nil )
     DEFAULT.read( path, sep: sep, converters: converters )
  end

  def self.header( path, sep: nil )
     DEFAULT.header( path, sep: sep )
  end

  def self.foreach( path, sep: nil,
                          converters: nil, &block )
     DEFAULT.foreach( path, sep: sep, converters: converters, &block )
  end



  #############################
  ## all "high-level" reader methods
  ##
  ## note: allow "overriding" of separator
  ##    if sep is not nil otherwise use default dialect/format separator

  def parse( data, sep: nil, limit: nil,
                   converters: nil, &block )
    kwargs = {
      limit:      limit,
      ##  converters: converters  ## todo: add converters
    }
    kwargs[:sep] = sep    unless sep.nil?   ## note: only add separator if present/defined (not nil)

    @parser.parse( data, kwargs, &block )
  end



  def parse_line( data, sep: nil,
                        converters: nil )
    records = parse( data, sep: sep, limit: 1 )

    ## unwrap record if empty return nil - why? why not?
    ##  return empty record e.g. [] - why? why not?
    records.size == 0 ? nil : records.first
  end

  def read( path, sep: nil,
                  converters: nil )
    ## note: use our own file.open
    ##   always use utf-8 for now
    ##    check/todo: add skip option bom too - why? why not?
    txt = File.open( path, 'r:bom|utf-8' ).read
    parse( txt, sep: sep )
  end

  def foreach( path, sep: nil,
                     converters: nil, &block )
    File.open( path, 'r:bom|utf-8' ) do |file|
      parse( file, sep: sep, &block )
    end
  end

  def header( path, sep: nil )   ## use header or headers - or use both (with alias)?
     # read first lines (only)
     #  and parse with csv to get header from csv library itself

     record = nil
     File.open( path, 'r:bom|utf-8' ) do |file|
        record = parse_line( file, sep: sep )
     end

     record  ## todo/fix: returns nil for empty - why? why not?
  end  # method self.header

end # class CsvReader
