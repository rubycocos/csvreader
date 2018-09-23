# encoding: utf-8


module Csv    ## check: rename to CsvSettings / CsvPref / CsvGlobals or similar - why? why not???



## todo/fix:
##   move dialect to its own file!

class Dialect   ## todo: use a module - it's just a namespace/module now - why? why not?
  ###
  # (auto-)add these flavors/dialects:
  #     :tab                   -> uses TabReader(!)
  #     :strict|:rfc4180
  #     :unix                   -> uses unix-style escapes e.g. \n \" etc.
  #     :windows|:excel
  #     :guess|:auto     -> guess (auto-detect) separator - why? why not?
  #     :mysql    -> add mysql flavor (see apache commons csv - why? why not?)

  # from apache commons csv
  #   see https://commons.apache.org/proper/commons-csv/apidocs/org/apache/commons/csv/CSVFormat.html
  #
  #  DEFAULT
  #    Standard comma separated format, as for RFC4180 but allowing empty lines.
  #  Settings are:
  #   withDelimiter(',')
  #   withQuote('"')
  #   withRecordSeparator("\r\n")
  #   withIgnoreEmptyLines(true)
  #
  #  EXCEL
  #    Excel file format (using a comma as the value delimiter).
  #     Note that the actual value delimiter used by Excel is locale dependent,
  #     it might be necessary to customize this format to accommodate to your regional settings.
  #     For example for parsing or generating a CSV file on a French system the following format will be used:
  #      CSVFormat fmt = CSVFormat.EXCEL.withDelimiter(';');
  #   Settings are:
  #     withSep(',')
  #     withQuote('"')
  #     withRecordSeparator("\r\n")
  #     withIgnoreEmptyLines(false)
  #     withAllowMissingColumnNames(true)
  #   Note: this is currently like RFC4180 plus withAllowMissingColumnNames(true).
  #
  #  MYSQL
  #   Default MySQL format used by the SELECT INTO OUTFILE and LOAD DATA INFILE operations.
  #   This is a tab-delimited format with a LF character as the line separator.
  #   Values are not quoted and special characters are escaped with '\'. The default NULL string is "\\N".
  #  Settings are:
  #    withSep('\t')
  #    withQuote(null)
  #    withRecordSeparator('\n')
  #    withIgnoreEmptyLines(false)
  #    withEscape('\\')
  #    withNullString("\\N")
  #    withQuoteMode(QuoteMode.ALL_NON_NULL)
  #
  #  POSTGRESQL_CSV
  #    Default PostgreSQL CSV format used by the COPY operation.
  #   This is a comma-delimited format with a LF character as the line separator.
  #   Values are double quoted and special characters are escaped with '"'. The default NULL string is "".
  #  Settings are:
  #    withSep(',')
  #    withQuote('"')
  #    withRecordSeparator('\n')
  #    withIgnoreEmptyLines(false)
  #    withEscape('\\')
  #    withNullString("")
  #    withQuoteMode(QuoteMode.ALL_NON_NULL)
  #
  #  POSTGRESQL_TEXT
  #    Default PostgreSQL text format used by the COPY operation.
  #    This is a tab-delimited format with a LF character as the line separator.
  #    Values are double quoted and special characters are escaped with '"'. The default NULL string is "\\N".
  #  Settings are:
  #    withSep('\t')
  #    withQuote('"')
  #    withRecordSeparator('\n')
  #    withIgnoreEmptyLines(false)
  #    withEscape('\\')
  #    withNullString("\\N")
  #    withQuoteMode(QuoteMode.ALL_NON_NULL)
  #
  #  RFC4180
  #     Comma separated format as defined by RFC 4180.
  #  Settings are:
  #    withSep(',')
  #    withQuote('"')
  #    withRecordSeparator("\r\n")
  #    withIgnoreEmptyLines(false)
  #
  #  TAB
  #     Tab-separated format.
  #   Settings are:
  #     withSep('\t')
  #     withQuote('"')
  #     withRecordSeparator("\r\n")
  #     withIgnoreSurroundingSpaces(true)




  ##  e.g. use Dialect.registry[:unix] = { ... } etc.
  ##   note use @@ - there is only one registry
  def self.registry() @@registry ||={} end

  ## add built-in dialects:
  ##    trim - use strip? why? why not? use alias?
  registry[:tab]     = {}   ##{ class: TabReader }
  registry[:strict]  = { strict: true, trim: false }   ## add no comments, blank lines, etc. ???
  registry[:rfc4180] = :strict    ## alternative name
  registry[:windows] = {}
  registry[:excel]   = :windows
  registry[:unix]    = {}

  ## todo: add some more
end  # class Dialect



  class Configuration


    attr_accessor :sep   ## col_sep (column separator)
    attr_accessor :na    ## not available (string or array of strings or nil) - rename to nas/nils/nulls - why? why not?
    attr_accessor :trim        ### allow ltrim/rtrim/trim - why? why not?
    attr_accessor :blanks
    attr_accessor :comments
    attr_accessor :dialect

    def initialize
      @sep      = ','
      @blanks   = true
      @comments = true
      @trim     = true
      ## note: do NOT add headers as global - should ALWAYS be explicit
      ##   headers (true/false) - changes resultset and requires different processing!!!

      self  ## return self for chaining
    end

    ## strip leading and trailing spaces
    def trim?() @trim; end

    ## skip blank lines (with only 1+ spaces)
    ## note: for now blank lines with no spaces will always get skipped
    def blanks?() @blanks; end


    def comments?() @comments; end


    ## built-in (default) options
    ##  todo: find a better name?
    def default_options
      ## note:
      ##   do NOT include sep character and
      ##   do NOT include headers true/false here
      ##
      ##  make default sep its own "global" default config
      ##   e.g. Csv.config.sep =

      ## common options
      ##   skip comments starting with #
      ##   skip blank lines
      ##   strip leading and trailing spaces
      ##    NOTE/WARN:  leading and trailing spaces NOT allowed/working with double quoted values!!!!
      defaults = {
        blanks:   @blanks,    ## note: skips lines with no whitespaces only!! (e.g. line with space is NOT blank!!)
        comments: @comments,
        trim:     @trim
        ## :converters => :strip
      }
      defaults
    end
  end # class Configuration


  ## lets you use
  ##   Csv.configure do |config|
  ##      config.sep = ','   ## or "/t"
  ##   end

  def self.configure
    yield( config )
  end

  def self.config
    @config ||= Configuration.new
  end
end   # module Csvv



####
## use our own wrapper

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

  def self.parse_line( data, sep: nil,
                             converters: nil )
     DEFAULT.parse_line( data, sep: sep, converters: converters )
  end

  def self.parse( data, sep: nil,
                        converters: nil )
     DEFAULT.parse( data, sep: sep, converters: converters )
  end

  #### fix!!! remove - replace with parse with (optional) block!!!!!
  def self.parse_lines( data, sep: nil,
                              converters: nil, &block )
     DEFAULT.parse_lines( data, sep: sep, converters: nil, &block )
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


  def parse_line( data, sep: nil,
                        converters: nil )
    sep = @parser.config[:sep]  if sep.nil?

    records = @parser.parse( data, sep: sep, limit: 1 )

    ## unwrap record if empty return nil - why? why not?
    ##  return empty record e.g. [] - why? why not?
    records.size == 0 ? nil : records.first
  end


  ##
  ##  todo/fix: "unify" parse and parse_lines  !!!
  ##    check for block_given? - why? why not?

  def parse( data, sep: nil,
                   converters: nil )
    sep = @parser.config[:sep]  if sep.nil?
    @parser.parse( data, sep: sep )
  end

  #### fix!!! remove - replace with parse with (optional) block!!!!!
  def parse_lines( data, sep: nil,
                         converters: nil, &block )
    sep = @parser.config[:sep]  if sep.nil?
    @parser.parse_lines( data, sep: sep, &block )
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
    sep = @parser.config[:sep]  if sep.nil?

    File.open( path, 'r:bom|utf-8' ) do |file|
      @parser.foreach( file, sep: sep, &block )
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




class CsvHashReader


def self.parse( data, sep: nil, headers: nil )

  ## pass in headers as array e.g. ['A', 'B', 'C']
  names = headers ? headers : nil

  records = []
  CsvReader.parse_lines( data ) do |values|     # sep: sep
    if names.nil?
      names = values   ## store header row / a.k.a. field/column names
    else
      record = names.zip( values ).to_h    ## todo/fix: check for more values than names/headers!!!
      records << record
    end
  end
  records
end


def self.read( path, sep: nil, headers: nil )
  txt = File.open( path, 'r:bom|utf-8' ).read
  parse( txt, sep: sep, headers: headers )
end


def self.foreach( path, sep: nil, headers: nil, &block )

  ## pass in headers as array e.g. ['A', 'B', 'C']
  names = headers ? headers : nil

  CsvReader.foreach( path ) do |values|     # sep: sep
    if names.nil?
      names = values   ## store header row / a.k.a. field/column names
    else
      record = names.zip( values ).to_h    ## todo/fix: check for more values than names/headers!!!
      block.call( record )
    end
  end
end


def self.header( path, sep: sep )   ## add header too? why? why not?
  ## same as "classic" header method - delegate/reuse :-)
  CsvReader.header( path, sep: sep )
end

end # class CsvHashReader
