
module Csv    ## check: rename to CsvSettings / CsvPref / CsvGlobals or similar - why? why not???


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
