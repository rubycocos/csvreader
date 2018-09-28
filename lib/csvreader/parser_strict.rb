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



def parse_escape( io )
  value = ""

  sep   = config[:sep]
  quote = config[:quote]

  if io.peek == BACKSLASH
    io.getc ## eat-up backslash
    if (c=io.peek; c==BACKSLASH || c==LF || c==CR || c==sep || (quote && c==quote) )
      value << io.getc     ## add escaped char (e.g. lf, cr, etc.)
    else
      ## unknown escape sequence; no special handling/escaping
      value << BACKSLASH
    end
  else
    puts "*** csv parse error: found >#{io.peek} (#{io.peek.ord})< - BACKSLASH (\\) expected in parse_escape!!!!"
    exit(1)
  end
  value
end



def parse_quote( io )
  value = ""

  quote       = config[:quote]
  doublequote = config[:doublequote]
  escape      = config[:escape]

  if io.peek == quote
    io.getc  ## eat-up double_quote

    loop do
      while (c=io.peek; !(c==quote || io.eof? || (escape && c==BACKSLASH)))
        value << io.getc   ## eat-up everything until hitting double_quote (") or backslash (escape)
      end

      if io.eof?
        break
      elsif io.peek == BACKSLASH
        value << parse_escape( io )
      else   ## assume io.peek == DOUBLE_QUOTE
        io.getc ## eat-up double_quote
        if doublequote && io.peek == quote  ## doubled up quote?
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
  value = ""

  quote  = config[:quote]
  escape = config[:escape]

  logger.debug "parse field - sep: >#{sep}< (#{sep.ord})"  if logger.debug?

  if (c=io.peek; c==sep || c==LF || c==CR || io.eof?) ## empty unquoted field
     value = config[:unquoted_empty]   ## defaults to "" (might be set to nil if needed)
     ## return value; do nothing
  elsif quote && io.peek == quote
    logger.debug "start quote field - peek >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
    value << parse_quote( io )

    value = config[:quoted_empty]  if value == ""   ## defaults to "" (might be set to nil if needed)

    logger.debug "end double_quote field - peek >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
  else
    logger.debug "start reg field - peek >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
    ## consume simple value
    ##   until we hit "," or "\n" or "\r" or stray (double) quote e.g (")
    while (c=io.peek; !(c==sep || c==LF || c==CR || io.eof? || (quote && c==quote)))
      if escape && io.peek == BACKSLASH
        value << parse_escape( io )
      else
        logger.debug "  add char >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
        value << io.getc
      end
    end
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
       skip_newline( io )   ## note: singular / single newline only (NOT plural)
       break
     elsif io.peek == sep
       io.getc   ## eat-up FS (,)
     else
       puts "*** csv parse error: found >#{io.peek} (#{io.peek.ord})< - FS (,) or RS (\\n) expected!!!!"
       exit(1)
     end
  end

  values
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



def parse_lines( io_maybe, sep: config[:sep], &block )
  ## find a better name for io_maybe
  ##   make sure io is a wrapped into BufferIO!!!!!!
  if io_maybe.is_a?( BufferIO )    ### allow (re)use of BufferIO if managed from "outside"
    io = io_maybe
  else
    io = BufferIO.new( io_maybe )
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
    break if io.eof?

    logger.debug "start record - peek >#{io.peek}< (#{io.peek.ord})"  if logger.debug?

    if comment && io.peek == comment        ## comment line
      logger.debug "skipping comment - peek >#{io.peek}< (#{io.peek.ord})"  if logger.debug?
      skip_until_eol( io )
      skip_newline( io )
    else
      record = parse_record( io, sep: sep )
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

def parse( io_maybe, sep: config[:sep], limit: nil )
  records = []

  parse_lines( io_maybe, sep: sep  ) do |record|
    records << record

    ## set limit to 1 for processing "single" line (that is, get one record)
    break  if limit && limit >= records.size
  end

  records
end ## method parse


end # class ParserStrict
end # class CsvReader
