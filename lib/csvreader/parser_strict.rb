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

def self.logger() @@logger ||= Logger.new( STDOUT ); end
def logger()  self.class.logger; end



attr_reader :config   ## todo/fix: change config to proper dialect class/struct - why? why not?

def initialize( sep:         ',',
                quote:       '"',  ## note: set to nil for no quote
                doublequote: true,
                na:          ['\N', 'NA'],  ## note: set to nil for no null vales / not availabe (na)
                quoted_empty:   '',
                unquoted_empty: '',
                comment:     nil,    ## note: comment char e.g. #
                escape:      nil    ## note: set to nil for no escapes
               )
  @config = {}   ## todo/fix: change config to proper dialect class/struct - why? why not?
  @config[:sep]          = sep
  @config[:quote]        = quote
  @config[:doublequote]  = doublequote
  @config[:escape]  = escape
  @config[:na]     = na
  @config[:quoted_empty] = quoted_empty
  @config[:unquoted_empty] = unquoted_empty
  @config[:comment] = comment
end



def parse_escape( input )
  value = ""

  sep   = config[:sep]
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
    puts "*** csv parse error: found >#{input.peek} (#{input.peek.ord})< - BACKSLASH (\\) expected in parse_escape!!!!"
    exit(1)
  end
  value
end



def parse_quote( input )
  value = ""

  quote       = config[:quote]
  doublequote = config[:doublequote]
  escape      = config[:escape]

  if input.peek == quote
    input.getc  ## eat-up double_quote

    loop do
      while (c=input.peek; !(c==quote || input.eof? || (escape && c==BACKSLASH)))
        value << input.getc   ## eat-up everything until hitting double_quote (") or backslash (escape)
      end

      if input.eof?
        break
      elsif input.peek == BACKSLASH
        value << parse_escape( input )
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
    puts "*** csv parse error: found >#{input.peek} (#{input.peek.ord})< - DOUBLE_QUOTE (\") expected in parse_double_quote!!!!"
    exit(1)
  end
  value
end



def parse_field( input, sep: )
  value = ""

  quote  = config[:quote]
  escape = config[:escape]

  logger.debug "parse field - sep: >#{sep}< (#{sep.ord})"  if logger.debug?

  if (c=input.peek; c==sep || c==LF || c==CR || input.eof?) ## empty unquoted field
     value = config[:unquoted_empty]   ## defaults to "" (might be set to nil if needed)
     ## return value; do nothing
  elsif quote && input.peek == quote
    logger.debug "start quote field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
    value << parse_quote( input )

    value = config[:quoted_empty]  if value == ""   ## defaults to "" (might be set to nil if needed)

    logger.debug "end double_quote field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
  else
    logger.debug "start reg field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
    ## consume simple value
    ##   until we hit "," or "\n" or "\r" or stray (double) quote e.g (")
    while (c=input.peek; !(c==sep || c==LF || c==CR || input.eof? || (quote && c==quote)))
      if escape && input.peek == BACKSLASH
        value << parse_escape( input )
      else
        logger.debug "  add char >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
        value << input.getc
      end
    end
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
       puts "*** csv parse error: found >#{input.peek} (#{input.peek.ord})< - FS (,) or RS (\\n) expected!!!!"
       exit(1)
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



def parse_lines( input_maybe, sep: config[:sep], &block )
  ## find a better name for input_maybe
  ##   make sure input is a wrapped into Buffer!!!!!!
  if input_maybe.is_a?( Buffer )    ### allow (re)use of Buffer if managed from "outside"
    input = input_maybe
  else
    input = Buffer.new( input_maybe )
  end


  ## todo/check: always pass along sep in methods (for easy overwrite/override) - why? why not?
  old_sep = config[:sep]
  config[:sep] = sep    if sep != config[:sep]


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

  ## restore sep(arator) if differnt
  config[:sep] = old_sep    if old_sep != config[:sep]
end # method parse_lines



##   fix: add optional block  - lets you use it like foreach!!!
##    make foreach an alias of parse with block - why? why not?
##
##   unifiy with (make one) parse and parse_lines!!!! - why? why not?

def parse( input_maybe, sep: config[:sep], limit: nil )
  records = []

  parse_lines( input_maybe, sep: sep  ) do |record|
    records << record

    ## set limit to 1 for processing "single" line (that is, get one record)
    break  if limit && limit >= records.size
  end

  records
end ## method parse


end # class ParserStrict
end # class CsvReader
