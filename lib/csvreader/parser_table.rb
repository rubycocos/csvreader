# encoding: utf-8

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

    ## note: requires block - enforce? how? why? why not?
    block.call( values )
  end
end # method parse_lines


end # class ParserTable
end # class CsvReader
