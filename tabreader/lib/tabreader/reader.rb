# encoding: utf-8


class TabReader

##
## add more configs - why? why not?
##   add comments and blanks (skip blank lines) - why? why not?
##   e.g. comments = '#'
##        blanks (skip blank lines)
##        rtrim,ltrim,trim

##
##  todo: add  converters: e.g. strip (akk trim / ltrim / rtrim )



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




def self.parse_line( line, sep: "\t" )
  ## check - can handle comments and blank lines too - why? why not?
  ## remove trailing newlines

  logger.debug  "line:"             if logger.debug?
  logger.debug line.pretty_inspect  if logger.debug?


  ##  note: chomp('') if is an empty string,
  ##    it will remove all trailing newlines from the string.
  ##    use line.sub(/[\n\r]*$/, '') or similar instead - why? why not?
  line = line.chomp( '' )

  ## line = line.strip         ## strip leading and trailing whitespaces (space/tab) too

  logger.debug line.pretty_inspect    if logger.debug?

#      if line.empty?             ## skip blank lines
#        logger.debug "skip blank line"    if logger.debug?
#        next
#      end

#      if line.start_with?( "#" )  ## skip comment lines
#        logger.debug "skip comment line"   if logger.debug?
#        next
#      end


    # note: trailing empty fields get (auto-)trimmed by split !!!!!!!
    #  Solution!!  change split( "\t" ) to split( "\t", -1 )
    #    If the limit parameter is omitted, trailing null fields are suppressed.
    #     If limit is a positive number, at most that number of fields will be returned
    #     (if limit is 1, the entire string is returned as the only entry in an array).
    #     If negative, there is no limit to the number of fields returned, and trailing null fields are not suppressed.
  values = line.split( sep, -1 )
  logger.debug values.pretty_inspect   if logger.debug?

  values
end




def self.open( path, mode=nil, &block )   ## rename path to filename or name - why? why not?

    ## note: default mode (if nil/not passed in) to 'r:bom|utf-8'
    f = File.open( path, mode ? mode : 'r:bom|utf-8' )
    tab = new( f )

    # handle blocks like Ruby's open()
    if block_given?
      begin
        block.call( tab )
      ensure
        tab.close
      end
    else
      tab
    end
end # method self.open


def self.read( path )
    open( path ) { |tab| tab.read }
end


def self.foreach( path, &block )
  tab = open( path )

  if block_given?
    begin
      tab.each( &block )
    ensure
      tab.close
    end
  else
    tab.to_enum    ## note: caller (responsible) must close file!!!
    ## remove version without block given - why? why not?
    ## use Tab.open().to_enum  or Tab.open().each
    ##   or Tab.new( File.new() ).to_enum or Tab.new( File.new() ).each ???
  end
end # method self.foreach


def self.parse( data, &block )
  tab = new( data )

  if block_given?
    tab.each( &block )  ## note: caller (responsible) must close file!!! - add autoclose - why? why not?
  else  # slurp contents, if no block is given
    tab.read            ## note: caller (responsible) must close file!!! - add autoclose - why? why not?
  end
end # method self.parse



## convenience helper for header (first row with column names)
def self.header( path )   ## use header or headers - or use both (with alias)?
  # read first lines (only)

  records = []
  open( path ) do |tab|
    tab.each do |record|
      records << record
      break   ## only parse/read first record
    end
  end

  ## unwrap record if empty return nil - why? why not?
  ##  return empty record e.g. [] - why? why not?
  ##  returns nil for empty (for now) - why? why not?
  records.size == 0 ? nil : records.first
end  # method self.header




def initialize( data )
  if data.is_a?( String )
    @input = data   # note: just needs each for each_line
  else  ## assume io
    @input = data
  end
end


include Enumerable

def each( &block )
  if block_given?
    @input.each_line do |line|

      values = self.class.parse_line( line )

      block.call( values )
    end
  else
     to_enum
  end
end # method each

def read() to_a; end # method read

def close
  @input.close   if @input.respond_to?(:close)   ## note: string needs no close
end

end # class TabReader
