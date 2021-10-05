
class CsvReader

class ParserTable

###################################
## add simple logger with debug flag/switch
#
#  use Parser.debug = true   # to turn on
#
#  todo/fix: use logutils instead of std logger - why? why not?

def self.build_logger()
  l = Logger.new( STDOUT )
  l.level = :info    ## set to :info on start; note: is 0 (debug) by default
  l
end
def self.logger() @@logger ||= build_logger; end
def logger()  self.class.logger; end




attr_reader   :config   ## todo/fix: change config to proper dialect class/struct - why? why not?

##
##  todo/check:
##    null values - include NA - why? why not?
##        make null values case sensitive or add an option for case sensitive
##        or better allow a proc as option for checking too!!!
def initialize( space: nil )
  @config = {}   ## todo/fix: change config to proper dialect class/struct - why? why not?

  ## e.g. treat/convert char to space e.g. _-+• etc
  ##   Man_Utd   => Man Utd
  ##  or use it for leading and trailing spaces without quotes
  ##  todo/check: only use for unquoted values? why? why not?
  @config[:space]   = space
end


#########################################
## config convenience helpers
def space=( value )       @config[:space]=value; end





def parse( str_or_readable, **kwargs, &block )

  ## note: input: required each_line (string or io/file for example)
  ## note: kwargs NOT used for now (but required for "protocol/interface" by other parsers)

  input = str_or_readable   ## assume it's a string or io/file handle

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

  space = config[:space]

  ## note: each line only works with \n (windows) or \r\n (unix)
  ##   will NOT work with \r (old mac, any others?) only!!!!
  input.each_line do |line|

    logger.debug  "line:"             if logger.debug?
    logger.debug line.pretty_inspect  if logger.debug?


    ##  note: chomp('') if is an empty string,
    ##    it will remove all trailing newlines from the string.
    ##    use line.sub(/[\n\r]*$/, '') or similar instead - why? why not?
    line = line.chomp( '' )
    line = line.strip         ## strip leading and trailing whitespaces (space/tab) too
    logger.debug line.pretty_inspect    if logger.debug?

    if line.empty?             ## skip blank lines
      logger.debug "skip blank line"    if logger.debug?
      next
    end

    if line.start_with?( "#" )  ## skip comment lines
      logger.debug "skip comment line"   if logger.debug?
      next
    end

    # note: string.split defaults to split by space (e.g. /\s+/) :-)
    #          for  just make it "explicit" with /[ \t]+/

    values = line.split( /[ \t]+/ )
    logger.debug values.pretty_inspect   if logger.debug?

    if space
      ## e.g. translate _-+ etc. if configured to space
      ##  Man_Utd => Man Utd etc.
       values = values.map {|value| value.tr(space,' ') }
    end

    ## note: requires block - enforce? how? why? why not?
    block.call( values )
  end
end # method parse_lines


end # class ParserTable
end # class CsvReader
