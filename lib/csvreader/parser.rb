# encoding: utf-8

class CsvReader



## todo: move logger to its own file!!!
class Logger
  def initialize( clazz )
    @clazz = clazz
  end

  def debug( msg )
    puts "[debug] #{msg}"  if @clazz.debug?
  end
end # class Logger




class Parser


## char constants
DOUBLE_QUOTE = "\""
COMMENT      = "#"      ## use COMMENT_HASH or HASH or ??
SPACE        = " "      ##   \s == ASCII 32 (dec)            =    (Space)
TAB          = "\t"     ##   \t == ASCII 0x09 (hex)          = HT (Tab/horizontal tab)
LF	         = "\n"     ##   \n == ASCII 0x0A (hex) 10 (dec) = LF (Newline/line feed)
CR	         = "\r"     ##   \r == ASCII 0x0D (hex) 13 (dec) = CR (Carriage return)


###################################
## add simple logger with debug flag/switch
#
#  use Parser.debug = true   # to turn on
def self.logger() @@logger ||= Logger.new( self ); end
def self.debug=(value) @@debug = value; end
def self.debug?() @@debug ||= false; end
def logger()  self.class.logger; end




attr_reader :config   ## todo/fix: change config to proper dialect class/struct - why? why not?

def initialize( sep:         Csv.config.sep,
                quote:       nil,
                doublequote: true,
                escape:      nil,
                trim:        Csv.config.trim? )
  @config = {}   ## todo/fix: change config to proper dialect class/struct - why? why not?
  @config[:sep]  = sep
  @config[:trim] = trim
end


def strict?
  ## note:  use trim for separating two different parsers / code paths:
  ##   - human with trim leading and trailing whitespace and
  ##   - strict with no leading and trailing whitespaces allowed

  ## for now use - trim == false for strict version flag alias
  ##   todo/fix: add strict flag - why? why not?
  @config[:trim] ? false : true
end


DEFAULT = new( sep: ',', trim: true )
RFC4180 = new( sep: ',', trim: false )
EXCEL   = new( sep: ',', trim: false )

def self.default()  DEFAULT; end    ## alternative alias for DEFAULT
def self.rfc4180()  RFC4180; end    ## alternative alias for RFC4180
def self.excel()    EXCEL; end      ## alternative alias for EXCEL




def parse_field( io, sep: config[:sep] )
  value = ""
  skip_spaces( io )   ## strip leading spaces

  if (c=io.peek; c=="," || c==LF || c==CR || io.eof?) ## empty field
     ## return value; do nothing
  elsif io.peek == DOUBLE_QUOTE
    logger.debug "start double_quote field - peek >#{io.peek}< (#{io.peek.ord})"
    io.getc  ## eat-up double_quote

    loop do
      while (c=io.peek; !(c==DOUBLE_QUOTE || io.eof?))
        value << io.getc   ## eat-up everything unit quote (")
      end

      break if io.eof?

      io.getc ## eat-up double_quote

      if io.peek == DOUBLE_QUOTE  ## doubled up quote?
        value << io.getc   ## add doube quote and continue!!!!
      else
        break
      end
    end

    ## note: always eat-up all trailing spaces (" ") and tabs (\t)
    skip_spaces( io )
    logger.debug "end double_quote field - peek >#{io.peek}< (#{io.peek.ord})"
  else
    logger.debug "start reg field - peek >#{io.peek}< (#{io.peek.ord})"
    ## consume simple value
    ##   until we hit "," or "\n" or "\r"
    ##    note: will eat-up quotes too!!!
    while (c=io.peek; !(c=="," || c==LF || c==CR || io.eof?))
      logger.debug "  add char >#{io.peek}< (#{io.peek.ord})"
      value << io.getc   ## eat-up all spaces (" ") and tabs (\t)
    end
    value = value.strip   ## strip all trailing spaces
    logger.debug "end reg field - peek >#{io.peek}< (#{io.peek.ord})"
  end

  value
end




def parse_field_strict( io, sep: config[:sep] )
  value = ""

  if (c=io.peek; c=="," || c==LF || c==CR || io.eof?) ## empty field
     ## return value; do nothing
  elsif io.peek == DOUBLE_QUOTE
    logger.debug "start double_quote field (strict) - peek >#{io.peek}< (#{io.peek.ord})"
    io.getc  ## eat-up double_quote

    loop do
      while (c=io.peek; !(c==DOUBLE_QUOTE || io.eof?))
        value << io.getc   ## eat-up everything unit quote (")
      end

      break if io.eof?

      io.getc ## eat-up double_quote

      if io.peek == DOUBLE_QUOTE  ## doubled up quote?
        value << io.getc   ## add doube quote and continue!!!!
      else
        break
      end
    end
    logger.debug "end double_quote field (strict) - peek >#{io.peek}< (#{io.peek.ord})"
  else
    logger.debug "start reg field (strict) - peek >#{io.peek}< (#{io.peek.ord})"
    ## consume simple value
    ##   until we hit "," or "\n" or "\r" or stroy "\"" double quote
    while (c=io.peek; !(c=="," || c==LF || c==CR || c==DOUBLE_QUOTE || io.eof?))
      logger.debug "  add char >#{io.peek}< (#{io.peek.ord})"
      value << io.getc
    end
    logger.debug "end reg field (strict) - peek >#{io.peek}< (#{io.peek.ord})"
  end

  value
end



def parse_record( io, sep: config[:sep] )
  values = []

  loop do
     value = parse_field( io, sep: sep )
     logger.debug "value: »#{value}«"
     values << value

     if io.eof?
        break
     elsif (c=io.peek; c==LF || c==CR)
       skip_newlines( io )
       break
     elsif io.peek == ","
       io.getc   ## eat-up FS(,)
     else
       puts "*** csv parse error: found >#{io.peek} (#{io.peek.ord})< - FS (,) or RS (\\n) expected!!!!"
       exit(1)
     end
  end

  values
end


def parse_record_strict( io, sep: config[:sep] )
  values = []

  loop do
     value = parse_field_strict( io )
     logger.debug "value: »#{value}«"
     values << value

     if io.eof?
        break
     elsif (c=io.peek; c==LF || c==CR)
       skip_newline( io )   ## note: singular / single newline only (NOT plural)
       break
     elsif io.peek == ","
       io.getc   ## eat-up FS(,)
     else
       puts "*** csv parse error (strict): found >#{io.peek} (#{io.peek.ord})< - FS (,) or RS (\\n) expected!!!!"
       exit(1)
     end
  end

  values
end



def skip_newlines( io )
  return if io.eof?

  while (c=io.peek; c==LF || c==CR)
    io.getc    ## eat-up all \n and \r
  end
end


def skip_newline( io )    ## note: singular (strict) version
  return if io.eof?

  ## only skip CR LF or LF or CR
  if io.peek == CR
    io.getc ## eat-up
    io.getc  if io.peek == LF
  elsif io.peek == LF
    io.getc ## eat-up
  else
    # do nothing
  end
end



def skip_until_eol( io )
  return if io.eof?

  while (c=io.peek; !(c==LF || c==CR || io.eof?))
    io.getc    ## eat-up all until end of line
  end
end

def skip_spaces( io )
  return if io.eof?

  while (c=io.peek; c==SPACE || c==TAB)
    io.getc   ## note: always eat-up all spaces (" ") and tabs (\t)
  end
end






def parse_lines_human( io, sep: config[:sep], &block )

  loop do
    break if io.eof?

    skip_spaces( io )

    if io.peek == COMMENT        ## comment line
      logger.debug "skipping comment - peek >#{io.peek}< (#{io.peek.ord})"
      skip_until_eol( io )
      skip_newlines( io )
    elsif (c=io.peek; c==LF || c==CR || io.eof?)
      logger.debug "skipping blank - peek >#{io.peek}< (#{io.peek.ord})"
      skip_newlines( io )
    else
      logger.debug "start record - peek >#{io.peek}< (#{io.peek.ord})"

      record = parse_record( io, sep: sep )
      ## note: requires block - enforce? how? why? why not?
      block.call( record )   ## yield( record )
    end
  end  # loop
end # method parse_lines_human



def parse_lines_strict( io, sep: config[:sep], &block )

  ## no leading and trailing whitespaces trimmed/stripped
  ## no comments skipped
  ## no blanks skipped
  ## - follows strict rules of
  ##  note: this csv format is NOT recommended;
  ##    please, use a format with comments, leading and trailing whitespaces, etc.
  ##    only added for checking compatibility

  loop do
    break if io.eof?

    logger.debug "start record (strict) - peek >#{io.peek}< (#{io.peek.ord})"

    record = parse_record_strict( io, sep: sep )

    ## note: requires block - enforce? how? why? why not?
    block.call( record )   ## yield( record )
  end  # loop
end # method parse_lines_strict



def parse_lines( io_maybe, sep: config[:sep], &block )
  ## find a better name for io_maybe
  ##   make sure io is a wrapped into BufferIO!!!!!!
  if io_maybe.is_a?( BufferIO )    ### allow (re)use of BufferIO if managed from "outside"
    io = io_maybe
  else
    io = BufferIO.new( io_maybe )
  end

  if strict?
    parse_lines_strict( io, sep: sep, &block )
  else
    parse_lines_human( io, sep: sep, &block )
  end
end  ## parse_lines


##   fix: add optional block  - lets you use it like foreach!!!
##    make foreach an alias of parse with block - why? why not?
##
##   unifiy with (make one) parse and parse_lines!!!! - why? why not?

def parse( io_maybe, sep: config[:sep], limit: nil )
  records = []

  parse_lines( io_maybe, sep: sep  ) do |record|
    records << record

    ## set limit to 1 for processing "single" line (that is, get one record)
    ##  use break instead of return records - why? why not?
    return records   if limit && limit >= records.size
  end

  records
end ## method parse


def foreach( io_maybe, sep: config[:sep], &block )
  parse_lines( io_maybe, sep: sep, &block )
end


end # class Parser
end # class CsvReader
