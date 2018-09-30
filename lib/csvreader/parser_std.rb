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

def initialize( na:          ['\N', 'NA']  ## note: set to nil for no null vales / not availabe (na)
              )
  @config = {}   ## todo/fix: change config to proper dialect class/struct - why? why not?
  @config[:na]     = na
end




def parse_escape( input )
  value = ""
  if input.peek == BACKSLASH
    input.getc ## eat-up backslash
    if (c=input.peek; c==BACKSLASH || c==LF || c==CR || c==',' || c=='"' )
      logger.debug "  add escaped char >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
      value << input.getc     ## add escaped char (e.g. lf, cr, etc.)
    else
      ## unknown escape sequence; no special handling/escaping
      logger.debug "  add backspace (unknown escape seq) >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
      value << BACKSLASH
    end
  else
    raise ParseError.new( "found >#{input.peek} (#{input.peek.ord})< - BACKSLASH (\\) expected in parse_escape!!!!" )
  end
  value
end


def parse_doublequote( input )
  value = ""
  if input.peek == DOUBLE_QUOTE
    input.getc  ## eat-up double_quote

    loop do
      while (c=input.peek; !(c==DOUBLE_QUOTE || c==BACKSLASH || input.eof?))
        value << input.getc   ## eat-up everything until hitting double_quote (") or backslash (escape)
      end

      if input.eof?
        break
      elsif input.peek == BACKSLASH
        value << parse_escape( input )
      else   ## assume input.peek == DOUBLE_QUOTE
        input.getc ## eat-up double_quote
        if input.peek == DOUBLE_QUOTE  ## doubled up quote?
          value << input.getc   ## add doube quote and continue!!!!
        else
          break
        end
      end
    end
  else
    raise ParseError.new( "found >#{input.peek} (#{input.peek.ord})< - DOUBLE_QUOTE (\") expected in parse_double_quote!!!!" )
  end
  value
end



def parse_field( input, sep: )
  logger.debug "parse field - sep: >#{sep}< (#{sep.ord})"  if logger.debug?

  value = ""
  skip_spaces( input )   ## strip leading spaces

  if (c=input.peek; c=="," || c==LF || c==CR || input.eof?) ## empty field
     ## return value; do nothing
  elsif input.peek == DOUBLE_QUOTE
    logger.debug "start double_quote field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
    value << parse_doublequote( input )

    ## note: always eat-up all trailing spaces (" ") and tabs (\t)
    skip_spaces( input )
    logger.debug "end double_quote field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
  else
    logger.debug "start reg field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
    ## consume simple value
    ##   until we hit "," or "\n" or "\r"
    ##    note: will eat-up quotes too!!!
    while (c=input.peek; !(c=="," || c==LF || c==CR || input.eof?))
      if input.peek == BACKSLASH
        value << parse_escape( input )
      else
        logger.debug "  add char >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
        value << input.getc   ## note: eat-up all spaces (" ") and tabs (\t) too (strip trailing spaces at the end)
      end
    end
    ##  note: only strip **trailing** spaces (space and tab only)
    ##    do NOT strip newlines etc. might have been added via escape! e.g. \\\n
    value = value.sub( /[ \t]+$/, '' )
    logger.debug "end reg field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
  end

  value
end



def parse_record( input, sep: )
  values = []

  loop do
     value = parse_field( input, sep: sep )
     logger.debug "value: »#{value}«"  if logger.debug?
     values << value

     if input.eof?
        break
     elsif (c=input.peek; c==LF || c==CR)
       skip_newline( input )
       break
     elsif input.peek == ","
       input.getc   ## eat-up FS(,)
     else
       raise ParseError.new( "found >#{input.peek} (#{input.peek.ord})< - FS (,) or RS (\\n) expected!!!!" )
     end
  end

  values
end



def skip_newline( input )    ## note: singular (strict) version
  return if input.eof?

  ## only skip CR LF or LF or CR
  if input.peek == CR
    input.getc ## eat-up
    input.getc  if input.peek == LF
  elsif input.peek == LF
    input.getc ## eat-up
  else
    # do nothing
  end
end



def skip_until_eol( input )
  return if input.eof?

  while (c=input.peek; !(c==LF || c==CR || input.eof?))
    input.getc    ## eat-up all until end of line
  end
end

def skip_spaces( input )
  return if input.eof?

  while (c=input.peek; c==SPACE || c==TAB)
    input.getc   ## note: always eat-up all spaces (" ") and tabs (\t)
  end
end






def parse_lines( input_maybe, sep: ',', &block )

  ## check/todo/fix: do NOT allow tab (\t)  a sep(arator)
  ##    if you use tab, use the parser_strict!!!!

  ## remove sep: config - why? why not?  yes, remove for now (keep it simple)!!!
  ##   allow semicolon (;) - why? why not? needed?
  ##
  ##   use parser_strict/flex for semicolon and more!!!


  ## find a better name for input_maybe
  ##   make sure input is a wrapped into Buffer!!!!!!
  if input_maybe.is_a?( Buffer )    ### allow (re)use of Buffer if managed from "outside"
    input = input_maybe
  else
    input = Buffer.new( input_maybe )
  end

  loop do
    break if input.eof?

    skip_spaces( input )

    if input.peek == COMMENT        ## comment line
      logger.debug "skipping comment - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
      skip_until_eol( input )
      skip_newline( input )
    elsif (c=input.peek; c==LF || c==CR || input.eof?)
      logger.debug "skipping blank - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
      skip_newline( input )
    else
      logger.debug "start record - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?

      record = parse_record( input, sep: sep )
      ## note: requires block - enforce? how? why? why not?
      block.call( record )   ## yield( record )
    end
  end  # loop
end # method parse_lines


##   fix: add optional block  - lets you use it like foreach!!!
##    make foreach an alias of parse with block - why? why not?
##
##   unifiy with (make one) parse and parse_lines!!!! - why? why not?

def parse( input_maybe, sep: ',', limit: nil )
  records = []

  parse_lines( input_maybe, sep: sep  ) do |record|
    records << record

    ## set limit to 1 for processing "single" line (that is, get one record)
    break  if limit && limit >= records.size
  end

  records
end ## method parse



end # class ParserStd
end # class CsvReader
