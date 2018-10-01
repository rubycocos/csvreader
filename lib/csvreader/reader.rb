# encoding: utf-8



class CsvReader

  def initialize( parser )
    @parser = parser
  end

  DEFAULT = new( Parser::DEFAULT )
  STRICT  = new( Parser::STRICT )
  RFC4180 = new( Parser::RFC4180 )
  EXCEL   = new( Parser::EXCEL )
  TAB     = new( Parser::TAB )

  def self.default()  DEFAULT; end    ## alternative alias for DEFAULT
  def self.strict()   STRICT; end     ## alternative alias for RFC4180
  def self.rfc4180()  RFC4180; end    ## alternative alias for RFC4180
  def self.excel()    EXCEL; end      ## alternative alias for EXCEL
  def self.tab()      TAB; end        ## alternative alias for TAB


  #####################
  ## convenience helpers defaulting to default csv dialect/format reader
  ##
  ##   CsvReader.parse is the same as
  ##     CsvReader::DEFAULT.parse or CsvReader.default.parse
  ##

  def self.parse( data, sep: nil,
                        converters: nil, &block )
     DEFAULT.parse( data, sep: sep, converters: converters, &block )
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


  ############################
  ## note: only add parse_line convenience helper for default
  ##   always use parse (do NOT use parse_line)  - why? why not?
  def self.parse_line( data, sep: nil,
                             converters: nil )
     records = []
     DEFAULT.parse( data, sep: sep, converters: converters ) do |record|
       records << record
       break   # only parse first record
     end
     records.size == 0 ? nil : records.first
  end



  #############################
  ## all "high-level" reader methods
  ##
  ## note: allow "overriding" of separator
  ##    if sep is not nil otherwise use default dialect/format separator

  def parse( data, sep: nil,
                   converters: nil, &block )
    kwargs = {
      ##  converters: converters  ## todo: add converters
    }
    ## note: only add separator if present/defined (not nil)
    kwargs[:sep] = sep    if sep && @parser.respond_to?( :'sep=' )

    @parser.parse( data, kwargs, &block )
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

     records = []
     File.open( path, 'r:bom|utf-8' ) do |file|
        parse( file, sep: sep ) do |record|
          records << record
          break   ## only parse/read first record
        end
     end

     ## unwrap record if empty return nil - why? why not?
     ##  return empty record e.g. [] - why? why not?
     ##  returns nil for empty (for now) - why? why not?
     records.size == 0 ? nil : records.first
  end  # method self.header

end # class CsvReader
