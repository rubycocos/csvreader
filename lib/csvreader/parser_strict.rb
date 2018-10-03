# encoding: utf-8

class CsvReader


class ParserStrict


## char constants
BACKSLASH    = "\\"    ## use BACKSLASH_ESCAPE ??
LF	         = "\n"     ##   \n == ASCII 0x0A (hex) 10 (dec) = LF (Newline/line feed)
CR	         = "\r"     ##   \r == ASCII 0x0D (hex) 13 (dec) = CR (Carriage return)


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



attr_reader :config   ## todo/fix: change config to proper dialect class/struct - why? why not?

def initialize( sep:         ',',
                quote:       '"',  ## note: set to false/nil for no quote
                doublequote: true,
                escape:      false,   ## true/false
                null:        nil,     ## note: set to nil for no null vales / not availabe (na)
                comment:     false   ## note: comment char e.g. # or false/nil
               )
  @config = {}   ## todo/fix: change config to proper dialect class/struct - why? why not?
  @config[:sep]          = sep
  @config[:quote]        = quote
  @config[:doublequote]  = doublequote
  @config[:escape]  = escape
  @config[:null]     = null
  @config[:comment] = comment
end

#########################################
## config convenience helpers
##   e.g. use like  Csv.mysql.sep = ','   etc.   instead of
##                  Csv.mysql.config[:sep] = ','
def sep=( value )         @config[:sep]=value; end
def quote=( value )       @config[:quote]=value; end
def doublequote=( value ) @config[:doublequote]=value; end
def escape=( value )      @config[:escape]=value; end
def null=( value )        @config[:null]=value; end
def comment=( value )     @config[:comment]=value; end



def parse( data, sep: config[:sep], &block )
  ## note: data - will wrap either a String or IO object passed in data

  ##   make sure data (string or io) is a wrapped into Buffer!!!!!!
  if data.is_a?( Buffer )    ### allow (re)use of Buffer if managed from "outside"
    input = data
  else
    input = Buffer.new( data )
  end


  if block_given?
    parse_lines( input, sep: sep, &block )
  else
    records = []

    parse_lines( input, sep: sep ) do |record|
      records << record
    end

    records
  end

end ## method parse



private

def parse_escape( input, sep: )
  value = ""

  quote = config[:quote]

  if input.peek == BACKSLASH
    input.getc ## eat-up backslash
    if (c=input.peek; c==BACKSLASH || c==LF || c==CR || c==sep || (quote && c==quote) )
      value << input.getc     ## add escaped char (e.g. lf, cr, etc.)
    else
      ## unknown escape sequence; no special handling/escaping
      value << BACKSLASH
    end
  else
    raise ParseError.new( "found >#{input.peek} (#{input.peek.ord})< - BACKSLASH (\\) expected in parse_escape!!!!" )
  end
  value
end



def parse_quote( input, sep: )
  value = ""

  quote       = config[:quote]         # char (e.g.",') | nil
  doublequote = config[:doublequote]   # true|false
  escape      = config[:escape]        # true|false

  if input.peek == quote
    input.getc  ## eat-up double_quote

    loop do
      while (c=input.peek; !(c==quote || input.eof? || (escape && c==BACKSLASH)))
        value << input.getc   ## eat-up everything until hitting double_quote (") or backslash (escape)
      end

      if input.eof?
        break
      elsif input.peek == BACKSLASH
        value << parse_escape( input, sep: sep )
      else   ## assume input.peek == DOUBLE_QUOTE
        input.getc ## eat-up double_quote
        if doublequote && input.peek == quote  ## doubled up quote?
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
  value = ""

  quote  = config[:quote]
  escape = config[:escape]

  logger.debug "parse field - sep: >#{sep}< (#{sep.ord})"  if logger.debug?

  if (c=input.peek; c==sep || c==LF || c==CR || input.eof?) ## empty unquoted field
    value = nil  if is_null?( value )   ## note: allows null = '' that is turn unquoted empty strings into null/nil
    ## return value; do nothing
  elsif quote && input.peek == quote
    logger.debug "start quote field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
    value << parse_quote( input, sep: sep )
    logger.debug "end double_quote field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
  else
    logger.debug "start reg field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
    ## consume simple value
    ##   until we hit "," or "\n" or "\r" or stray (double) quote e.g (")
    while (c=input.peek; !(c==sep || c==LF || c==CR || input.eof? || (quote && c==quote)))
      if escape && input.peek == BACKSLASH
        value << parse_escape( input, sep: sep )
      else
        logger.debug "  add char >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
        value << input.getc
      end
    end

    value = nil  if is_null?( value )   ## note: null check only for UNQUOTED (not quoted/escaped) values
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
       skip_newline( input )   ## note: singular / single newline only (NOT plural)
       break
     elsif input.peek == sep
       input.getc   ## eat-up FS (,)
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



def parse_lines( input, sep:, &block )
  ## no leading and trailing whitespaces trimmed/stripped
  ## no comments skipped
  ## no blanks skipped
  ## - follows strict rules of
  ##  note: this csv format is NOT recommended;
  ##    please, use a format with comments, leading and trailing whitespaces, etc.
  ##    only added for checking compatibility

  comment = config[:comment]

  loop do
    break if input.eof?

    logger.debug "start record - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?

    if comment && input.peek == comment        ## comment line
      logger.debug "skipping comment - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
      skip_until_eol( input )
      skip_newline( input )
    else
      record = parse_record( input, sep: sep )
      ## note: requires block - enforce? how? why? why not?
      block.call( record )   ## yield( record )
    end
  end  # loop

end # method parse_lines


def is_null?( value )
   null = @config[:null]
   if null.nil?
     false  ## nothing set; return always false (not null)
   elsif null.is_a?( Proc )
     null.call( value )
   elsif null.is_a?( Array )
     null.include?( value )
   elsif null.is_a?( String )
     value == null
   else  ## unknown config style / setting
     ##  todo: issue a warning or error - why? why not?
     false  ## nothing set; return always false (not null)
   end
end


end # class ParserStrict
end # class CsvReader
