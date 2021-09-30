# encoding: utf-8


class CsvYaml

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





def self.open( path, mode=nil, &block )   ## rename path to filename or name - why? why not?

    ## note: default mode (if nil/not passed in) to 'r:bom|utf-8'
    f = File.open( path, mode ? mode : 'r:bom|utf-8' )
    csv = new( f )

    # handle blocks like Ruby's open()
    if block_given?
      begin
        block.call( csv )
      ensure
        csv.close
      end
    else
      csv
    end
end # method self.open


def self.read( path )
    open( path ) { |csv| csv.read }
end


def self.foreach( path, &block )
  csv = open( path )

  if block_given?
    begin
      csv.each( &block )
    ensure
      csv.close
    end
  else
    csv.to_enum    ## note: caller (responsible) must close file!!!
    ## remove version without block given - why? why not?
    ## use Csv.open().to_enum  or Csv.open().each
    ##   or Csv.new( File.new() ).to_enum or Csv.new( File.new() ).each ???
  end
end # method self.foreach


def self.parse( str_or_readable, &block )
  csv = new( str_or_readable )

  if block_given?
    csv.each( &block )  ## note: caller (responsible) must close file!!! - add autoclose - why? why not?
  else  # slurp contents, if no block is given
    csv.read            ## note: caller (responsible) must close file!!! - add autoclose - why? why not?
  end
end # method self.parse



def initialize( str_or_readable )
  if str_or_readable.is_a?( String )
    @input = str_or_readable   # note: just needs each for each_line
  else  ## assume io
    @input = str_or_readable
  end
end



include Enumerable

def each( &block )
  if block_given?
    @input.each_line do |line|

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

      ## note: auto-wrap in array e.g. with []
      ##   add document marker (---) why? why not?
      values = YAML.load( "---\n[#{line}]" )
      logger.debug values.pretty_inspect   if logger.debug?
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

end # class CsvYaml
