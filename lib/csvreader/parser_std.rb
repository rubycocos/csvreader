# encoding: utf-8

class CsvReader





class ParserStd


## char constants
DOUBLE_QUOTE = "\""
BACKSLASH    = "\\"    ## use BACKSLASH_ESCAPE ??
COMMENT      = "#"      ## use COMMENT_HASH or HASH or ??
SPACE        = " "      ##   \s == ASCII 32 (dec)            =    (Space)
TAB          = "\t"     ##   \t == ASCII 0x09 (hex)          = HT (Tab/horizontal tab)
LF	         = "\n"     ##   \n == ASCII 0x0A (hex) 10 (dec) = LF (Newline/line feed)
CR	         = "\r"     ##   \r == ASCII 0x0D (hex) 13 (dec) = CR (Carriage return)


###################################
## add simple logger with debug flag/switch
#
#  use Parser.debug = true   # to turn on
#
#  todo/fix: use logutils instead of std logger - why? why not?

def self.logger() @@logger ||= Logger.new( STDOUT ); end
def logger()  self.class.logger; end



attr_reader :config   ## todo/fix: change config to proper dialect class/struct - why? why not?

def initialize( sep: ',',
                na:          ['\N', 'NA']  ## note: set to nil for no null vales / not availabe (na)
               )
  @config = {}   ## todo/fix: change config to proper dialect class/struct - why? why not?
  @config[:sep]    = sep
  @config[:na]     = na
end




def parse_escape( io )
  value = ""
  if io.peek == BACKSLASH
    io.getc ## eat-up backslash
    if (c=io.peek; c==BACKSLASH || c==LF || c==CR || c==',' || c=='"' )
      logger.debug "  add escaped char >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
      value << io.getc     ## add escaped char (e.g. lf, cr, etc.)
    else
      ## unknown escape sequence; no special handling/escaping
      logger.debug "  add backspace (unknown escape seq) >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
      value << BACKSLASH
    end
  else
    puts "*** csv parse error: found >#{io.peek} (#{io.peek.ord})< - BACKSLASH (\\) expected in parse_escape!!!!"
    exit(1)
  end
  value
end


def parse_doublequote( io )
  value = ""
  if io.peek == DOUBLE_QUOTE
    io.getc  ## eat-up double_quote

    loop do
      while (c=io.peek; !(c==DOUBLE_QUOTE || c==BACKSLASH || io.eof?))
        value << io.getc   ## eat-up everything until hitting double_quote (") or backslash (escape)
      end

      if io.eof?
        break
      elsif io.peek == BACKSLASH
        value << parse_escape( io )
      else   ## assume io.peek == DOUBLE_QUOTE
        io.getc ## eat-up double_quote
        if io.peek == DOUBLE_QUOTE  ## doubled up quote?
          value << io.getc   ## add doube quote and continue!!!!
        else
          break
        end
      end
    end
  else
    puts "*** csv parse error: found >#{io.peek} (#{io.peek.ord})< - DOUBLE_QUOTE (\") expected in parse_double_quote!!!!"
    exit(1)
  end
  value
end



def parse_field( io, sep: )
  logger.debug "parse field - sep: >#{sep}< (#{sep.ord})"  if logger.debug?

  value = ""
  skip_spaces( io )   ## strip leading spaces

  if (c=io.peek; c=="," || c==LF || c==CR || io.eof?) ## empty field
     ## return value; do nothing
  elsif io.peek == DOUBLE_QUOTE
    logger.debug "start double_quote field - peek >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
    value << parse_doublequote( io )

    ## note: always eat-up all trailing spaces (" ") and tabs (\t)
    skip_spaces( io )
    logger.debug "end double_quote field - peek >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
  else
    logger.debug "start reg field - peek >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
    ## consume simple value
    ##   until we hit "," or "\n" or "\r"
    ##    note: will eat-up quotes too!!!
    while (c=io.peek; !(c=="," || c==LF || c==CR || io.eof?))
      if io.peek == BACKSLASH
        value << parse_escape( io )
      else
        logger.debug "  add char >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
        value << io.getc   ## note: eat-up all spaces (" ") and tabs (\t) too (strip trailing spaces at the end)
      end
    end
    ##  note: only strip **trailing** spaces (space and tab only)
    ##    do NOT strip newlines etc. might have been added via escape! e.g. \\\n
    value = value.sub( /[ \t]+$/, '' )
    logger.debug "end reg field - peek >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
  end

  value
end



def parse_record( io, sep: )
  values = []

  loop do
     value = parse_field( io, sep: sep )
     logger.debug "value: »#{value}«"  if logger.debug?
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





def skip_newlines( io )
  return if io.eof?

  while (c=io.peek; c==LF || c==CR)
    io.getc    ## eat-up all \n and \r
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






def parse_lines( io_maybe, sep: config[:sep], &block )

  ## check/todo/fix: do NOT allow tab (\t)  a sep(arator)
  ##    if you use tab, use the parser_strict!!!!

  ## remove sep: config - why? why not?  yes, remove for now (keep it simple)!!!
  ##   allow semicolon (;) - why? why not? needed?
  ##
  ##   use parser_strict/flex for semicolon and more!!!


  ## find a better name for io_maybe
  ##   make sure io is a wrapped into BufferIO!!!!!!
  if io_maybe.is_a?( BufferIO )    ### allow (re)use of BufferIO if managed from "outside"
    io = io_maybe
  else
    io = BufferIO.new( io_maybe )
  end

  loop do
    break if io.eof?

    skip_spaces( io )

    if io.peek == COMMENT        ## comment line
      logger.debug "skipping comment - peek >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
      skip_until_eol( io )
      skip_newlines( io )
    elsif (c=io.peek; c==LF || c==CR || io.eof?)
      logger.debug "skipping blank - peek >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
      skip_newlines( io )
    else
      logger.debug "start record - peek >#{io.peek}< (#{io.peek.ord})"  if logger.debug?

      record = parse_record( io, sep: sep )
      ## note: requires block - enforce? how? why? why not?
      block.call( record )   ## yield( record )
    end
  end  # loop
end # method parse_lines


##   fix: add optional block  - lets you use it like foreach!!!
##    make foreach an alias of parse with block - why? why not?
##
##   unifiy with (make one) parse and parse_lines!!!! - why? why not?

def parse( io_maybe, sep: config[:sep], limit: nil )
  records = []

  parse_lines( io_maybe, sep: sep  ) do |record|
    records << record

    ## set limit to 1 for processing "single" line (that is, get one record)
    break  if limit && limit >= records.size
  end

  records
end ## method parse



end # class ParserStd
end # class CsvReader
