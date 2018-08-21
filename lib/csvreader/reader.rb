# encoding: utf-8


module Csv    ## check: rename to CsvSettings / CsvPref / CsvGlobals or similar - why? why not???


class Dialect   ## todo: use a module - it's just a namespace/module now - why? why not?
  ###
  # (auto-)add these flavors/dialects:
  #     :tab                   -> uses TabReader(!)
  #     :strict|:rfc4180
  #     :unix                   -> uses unix-style escapes e.g. \n \" etc.
  #     :windows|:excel
  #     :guess|:auto     -> guess (auto-detect) separator - why? why not?

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

  def self.parse_line( txt, sep:        Csv.config.sep,
                            trim:       Csv.config.trim?,
                            na:         Csv.config.na,
                            dialect:    Csv.config.dialect,
                            converters: nil)
    ## note: do NOT include headers option (otherwise single row gets skipped as first header row :-)
    csv_options = Csv.config.default_options.merge(
                    col_sep: sep
    )
    ## pp csv_options
    Parser.parse_line( txt )  ##, csv_options )
  end


  ##
  ##  todo/fix: "unify" parse and parse_lines  !!!
  ##    check for block_given? - why? why not?

  def self.parse( txt, sep: Csv.config.sep )
    csv_options = Csv.config.default_options.merge(
                     col_sep: sep
    )
    ## pp csv_options
    Parser.parse( txt )  ###, csv_options )
  end

  def self.parse_lines( txt, sep: Csv.config.sep, &block )
    csv_options = Csv.config.default_options.merge(
                     col_sep: sep
    )
    ## pp csv_options
    Parser.parse_lines( txt, &block )  ###, csv_options )
  end

  def self.read( path, sep: Csv.config.sep )
    ## note: use our own file.open
    ##   always use utf-8 for now
    ##    check/todo: add skip option bom too - why? why not?
    txt = File.open( path, 'r:bom|utf-8' ).read
    parse( txt, sep: sep )
  end


  def self.foreach( path, sep: Csv.config.sep, &block )
    csv_options = Csv.config.default_options.merge(
                     col_sep: sep
    )

    Parser.foreach( path, &block ) ###, csv_options )
  end


  def self.header( path, sep: Csv.config.sep )   ## use header or headers - or use both (with alias)?
      # read first lines (only)
      #  and parse with csv to get header from csv library itself
      #
      #  check - if there's an easier or built-in way for the csv library

      ## readlines until
      ##  - NOT a comments line or
      ##  - NOT a blank line

     record = nil
     File.open( path, 'r:bom|utf-8' ) do |file|
        record = Parser.parse_line( file )
     end

     record  ## todo/fix: return nil for empty - why? why not?
    end  # method self.header

end # class CsvReader




class CsvHashReader


def self.parse( txt, sep: Csv.config.sep, headers: nil )

  ## pass in headers as array e.g. ['A', 'B', 'C']
  names = headers ? headers : nil

  records = []
  CsvReader.parse_lines( txt ) do |values|     # sep: sep
    if names.nil?
      names = values   ## store header row / a.k.a. field/column names
    else
      record = names.zip( values ).to_h    ## todo/fix: check for more values than names/headers!!!
      records << record
    end
  end
  records
end


def self.read( path, sep: Csv.config.sep, headers: nil )
  txt = File.open( path, 'r:bom|utf-8' ).read
  parse( txt, sep: sep, headers: headers )
end


def self.foreach( path, sep: Csv.config.sep, headers: nil, &block )

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


def self.header( path, sep: Csv.config.sep )   ## add header too? why? why not?
  ## same as "classic" header method - delegate/reuse :-)
  CsvReader.header( path, sep: sep )
end

end # class CsvHashReader
