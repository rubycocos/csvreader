
class CsvReader





class ParserStd


## char constants
DOUBLE_QUOTE  = "\""
SINGLE_QUOTE  = "'"
BACKSLASH     = "\\"    ## use BACKSLASH_ESCAPE ??
COMMENT_HASH    = "#"      ## use COMMENT1 or COMMENT_HASH or HASH or ??
COMMENT_PERCENT = "%"      ## use COMMENT2 or COMMENT_PERCENT or PERCENT or ??
DIRECTIVE     = "@"     ## use a different name e.g. AT or ??
SPACE         = " "      ##   \s == ASCII 32 (dec)            =    (Space)
TAB           = "\t"     ##   \t == ASCII 0x09 (hex)          = HT (Tab/horizontal tab)
LF	          = "\n"     ##   \n == ASCII 0x0A (hex) 10 (dec) = LF (Newline/line feed)
CR	          = "\r"     ##   \r == ASCII 0x0D (hex) 13 (dec) = CR (Carriage return)



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
attr_reader   :meta

##
##  todo/check:
##    null values - include NA - why? why not?
##        make null values case sensitive or add an option for case sensitive
##        or better allow a proc as option for checking too!!!
def initialize( sep:      ',',
                null:     ['\N', 'NA'],  ## note: set to nil for no null vales / not availabe (na)
                numeric:  false,   ## (auto-)convert all non-quoted values to float
                nan:      nil,      ## note: only if numeric - set mappings for Float::NAN (not a number) values
                space:    nil,
                hashtag:  false
              )
  @config = {}   ## todo/fix: change config to proper dialect class/struct - why? why not?

  check_sep( sep )
  @config[:sep]     = sep

  ## note: null values must get handled by parser
  ##   only get checked for unquoted strings (and NOT for quoted strings)
  ##   "higher-level" code only knows about strings and has no longer any info if string was quoted or unquoted
  @config[:null]    = null   ## null values
  @config[:numeric] = numeric
  @config[:nan]     = nan   # not a number (NaN) e.g. Float::NAN

  ## e.g. treat/convert char to space e.g. _-+• etc
  ##   Man_Utd   => Man Utd
  ##  or use it for leading and trailing spaces without quotes
  ##  todo/check: only use for unquoted values? why? why not?
  @config[:space]   = space

  ## hxl - humanitarian eXchange language uses a hashtag row for "meta data"
  ##  e.g. #sector+en,#subsector,#org,#country,#sex+#targeted,#sex+#targeted,#adm1
  ##  do NOT treat # as a comment (always use % for now)
  @config[:hashtag] = hashtag

  @meta  = nil     ## no meta data block   (use empty hash {} - why? why not?)
end


  SEPARATORS = ",;|^:"

def check_sep( sep )
  ## note: parse does NOT support space or tab as separator!!
  ##    leading and trailing space or tab (whitespace) gets by default trimmed
  ##      unless quoted (or alternative space char used e.g. _-+ if configured)

  if SEPARATORS.include?( sep )
     ## everything ok
  else
    raise ArgumentError, "invalid/unsupported sep >#{sep}< - for now only >#{SEPARATORS}< allowed; sorry"
  end
end


#########################################
## config convenience helpers
##   e.g. use like  Csv.defaultl.null = '\N'   etc.   instead of
##                  Csv.default.config[:null] = '\N'
def sep=( value )         check_sep( value );  @config[:sep]=value; end

def null=( value )        @config[:null]=value; end
def numeric=( value )     @config[:numeric]=value; end
def nan=( value )         @config[:nan]=value; end
def space=( value )       @config[:space]=value; end
def hashtag=( value )     @config[:hashtag]=value; end




def parse( str_or_readable, sep: config[:sep], &block )

  check_sep( sep )

  ## note: data - will wrap either a String or IO object passed in data
  ## note: kwargs NOT used for now (but required for "protocol/interface" by other parsers)

  ##   make sure data (string or io) is a wrapped into Buffer!!!!!!
  if str_or_readable.is_a?( Buffer )    ### allow (re)use of Buffer if managed from "outside"
    input = str_or_readable
  else
    input = Buffer.new( str_or_readable )
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
  if input.peek == BACKSLASH
    input.getc ## eat-up backslash
    if (c=input.peek; c==BACKSLASH || c==LF || c==CR || c==sep || c==DOUBLE_QUOTE || c==SINGLE_QUOTE )
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



def parse_quote( input, sep:, opening_quote:, closing_quote:)
  value = ""
  if input.peek == opening_quote
    input.getc  ## eat-up opening quote

    loop do
      while (c=input.peek; !(c==closing_quote || c==BACKSLASH || input.eof?))
        value << input.getc   ## eat-up everything until hitting quote (e.g. " or ') or backslash (escape)
      end

      if input.eof?
        break
      elsif input.peek == BACKSLASH
        value << parse_escape( input, sep: sep )
      else   ## assume input.peek == quote
        input.getc ## eat-up quote
        if opening_quote == closing_quote && input.peek == closing_quote
          ## doubled up quote?
          #   note: only works (enabled) for "" or '' and NOT for «»,‹›.. (if opening and closing differ)
          value << input.getc   ## add doube quote and continue!!!!
        else
          break
        end
      end
    end
  else
    raise ParseError.new( "found >#{input.peek} (#{input.peek.ord})< - CLOSING QUOTE (#{closing_quote}) expected in parse_quote!!!!" )
  end
  value
end


def parse_field_until_sep( input, sep: )
  value = ""
  logger.debug "start reg field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
  ## consume simple value
  ##   until we hit "," or "\n" or "\r"
  ##    note: will eat-up quotes too!!!
  while (c=input.peek; !(c==sep || c==LF || c==CR || input.eof?))
    if input.peek == BACKSLASH
      value << parse_escape( input, sep: sep )
    else
      logger.debug "  add char >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
      value << input.getc   ## note: eat-up all spaces (" ") and tabs (\t) too (strip trailing spaces at the end)
    end
  end
  ##  note: only strip **trailing** spaces (space and tab only)
  ##    do NOT strip newlines etc. might have been added via escape! e.g. \\\n
  value = value.sub( /[ \t]+$/, '' )
  value
end



def parse_field( input, sep: )
  value = ""

  numeric = config[:numeric]
  hashtag = config[:hashtag]


  logger.debug "parse field"  if logger.debug?

  skip_spaces( input )   ## strip leading spaces


  if (c=input.peek; c==sep || c==LF || c==CR || input.eof?) ## empty field
    ## note: allows null = '' that is turn unquoted empty strings into null/nil
    ##   or if using numeric into NotANumber (NaN)
    if is_null?( value )
      value = nil
    elsif numeric && is_nan?( value )  ## todo: check - how to handle numeric? return nil, NaN, or "" ???
      value = Float::NAN
    else
      # do nothing - keep value as is :-) e.g. "".
    end
  elsif input.peek == DOUBLE_QUOTE
    logger.debug "start double_quote field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
    value << parse_quote( input, sep: sep,
                                 opening_quote: DOUBLE_QUOTE,
                                 closing_quote: DOUBLE_QUOTE )

    ## note: always eat-up all trailing spaces (" ") and tabs (\t)
    spaces_count = skip_spaces( input )

    ##  check for auto-fix trailing data after quoted value e.g. ---,"Fredy" Mercury,---
    ##   todo/fix: add auto-fix for all quote variants!!!!!!!!!!!!!!!!!!!!
    if (c=input.peek; c==sep || c==LF || c==CR || input.eof?)
       ## everything ok (that is, regular quoted value)!!!
    else
      ## try auto-fix
      ##   todo: report warning/issue error (if configured)!!!
      extra_value = parse_field_until_sep( input, sep: sep )
      ## "reconstruct" non-quoted value
      spaces = ' ' * spaces_count   ## todo: preserve tab (\t) - why? why not?
      ## note: minor (theoratical) issue (doubled quoted got "collapsed/escaped" to one from two in quoted value)
      ##    e.g. "hello """ extra,  (becomes)=>  "hello "" extra (one quote less/"eaten up")
      value = %Q{"#{value}"#{spaces}#{extra_value}}
    end

    logger.debug "end double_quote field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
  elsif input.peek == SINGLE_QUOTE    ## allow single quote too (by default)
    logger.debug "start single_quote field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
    value << parse_quote( input, sep: sep,
                                 opening_quote: SINGLE_QUOTE,
                                 closing_quote: SINGLE_QUOTE )

    ## note: always eat-up all trailing spaces (" ") and tabs (\t)
    skip_spaces( input )
    logger.debug "end single_quote field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
  elsif input.peek == "«"
    value << parse_quote( input, sep: sep,
                                 opening_quote: "«",
                                 closing_quote: "»" )
    skip_spaces( input )
  elsif input.peek == "»"
    value << parse_quote( input, sep: sep,
                                 opening_quote: "»",
                                 closing_quote: "«" )
    skip_spaces( input )
  elsif input.peek == "‹"
    value << parse_quote( input, sep: sep,
                                 opening_quote: "‹",
                                 closing_quote: "›" )
    skip_spaces( input )
  elsif input.peek == "›"
    value << parse_quote( input, sep: sep,
                                 opening_quote: "›",
                                 closing_quote: "‹" )
    skip_spaces( input )
  else
    logger.debug "start reg field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
    ## consume simple value
    ##   until we hit "," or "\n" or "\r"
    ##    note: will eat-up quotes too!!!
    while (c=input.peek; !(c==sep || c==LF || c==CR || input.eof?))
      if input.peek == BACKSLASH
        value << parse_escape( input, sep: sep )
      ###   check for end-of-line comments (e.g. # ...)
      ##    note: quick hack for now
      ##      will NOT work in hashtag (hxl) mode and for % comments
      ##      for now ALWAYS assumes # for comments
      ##      and end-of-line comments ONLY work here (that is, in unquoted values and NOT in quotes values) for now
      ##    todo/fix: note: require leading space for comment hash (#) for now- why? why not?
      ##                    require trailing space after comment hash (#) - why? why not?
    elsif (hashtag == false || hashtag.nil?) && input.peek == COMMENT_HASH &&
           (value.size == 0 || (value.size > 0 && value[-1] == ' '))
        ## eat-up everything until end-of-line (eol)
        skip_until_eol( input )
      else
        logger.debug "  add char >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
        value << input.getc   ## note: eat-up all spaces (" ") and tabs (\t) too (strip trailing spaces at the end)
      end
    end
    ##  note: only strip **trailing** spaces (space and tab only)
    ##    do NOT strip newlines etc. might have been added via escape! e.g. \\\n
    value = value.sub( /[ \t]+$/, '' )

    if is_null?( value )   ## note: null check only for UNQUOTED (not quoted/escaped) values
      value = nil
    elsif numeric
      if is_nan?( value )
        value = Float::NAN
      else
        ## numeric - (auto-convert) non-quoted values (if NOT nil) to floats
        if numeric.is_a?( Proc )
          value = numeric.call( value )   ## allow custom converter proc (e.g. how to handle NaN and conversion errors?)
        else
          value = convert_to_float( value ) # default (fails silently) keep string value if cannot convert - change - why? why not?
        end
      end
    else
      # do nothing - keep value as is :-).
    end

    logger.debug "end reg field - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
  end

  value
end



def parse_record( input, sep: )
  values = []

  space   = config[:space]

  loop do
     value = parse_field( input, sep: sep )
     value = value.tr( space, ' ' )   if space && value.is_a?( String )

     logger.debug "value: »#{value}«"  if logger.debug?
     values << value

     if input.eof?
        break
     elsif (c=input.peek; c==LF || c==CR)
       skip_newline( input )
       break
     elsif input.peek == sep
       input.getc   ## eat-up FS(,)
     else
       raise ParseError.new( "found >#{input.peek} (#{input.peek.ord})< - FS (#{sep}) or RS (\\n) expected!!!!" )
     end
  end

  values
end



def parse_meta( input )
  ## todo/check:
  ##  check again for input.peekn(4) =~ /^---[\n\r \t]$/ - why? why not?

  input.getc   ## eat-up (add document header ---) - skip "---"
  input.getc
  input.getc

  ## todo/fix: make peekn(4)=~/^---[\n\r \t]$/ "more strict"
  ##    use match() or something to always match regexp
  skip_spaces( input )   # eat-up optional whitespaces in header line
  skip_newline( input )

  buf = "---\n"    ## note: start buffer with yaml header line - why?
  ##   ::YAML.load("")        return false !!!
  ##   ::YAML.load("---\n")   returns nil -- yes!!  if we get nil return empty hash {}

  newline = true

  ## eat-up until we hit "---" again
  loop do
    if input.eof?
      raise ParseError.new( "end of input/stream - meta block footer >---< expected!!!!" )
    elsif (c=input.peek; c==LF || c==CR)
      while (c=input.peek; c==LF || c==CR )   ## add newlines
        buf << input.getc    ## eat-up all until end of line
      end
      newline = true
    elsif newline && input.peekn(4) =~ /^---[\n\r \t]?$/   ## check if meta block end marker?
      ## todo/fix/check: allow (ignore) spaces after ---  why? why not?
      input.getc   ## eat-up (add document header ---) - skip "---"
      input.getc
      input.getc
      skip_spaces( input )   # eat-up optional whitespaces in header line
      skip_newline( input )
      break
    else
      buf << input.getc
      newline = false
    end
  end

  data = ::YAML.load( buf )  ## note: MUST use "outer" scope (CsvReader defines its own YAML parser)
  ## todo: check edge cases - always should return a hash or nil
  ##     what to do with just integer, string or array etc. ???

  data = {}   if data.nil?     ## note: if nil return empty hash e.g. {}
  data
end  ## parse_meta



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
  return 0   if input.eof?

  ## note: return number of spaces skipped (e.g. 0,1,2,etc.)
  spaces_count = 0
  while (c=input.peek; c==SPACE || c==TAB)
    input.getc   ## note: always eat-up all spaces (" ") and tabs (\t)
    spaces_count += 1
  end
  spaces_count
end






def parse_lines( input, sep:, &block )
  ## note: reset (optional) meta data block
  @meta  = nil     ## no meta data block   (use empty hash {} - why? why not?)

  ## note: track number of records
  ##   used for meta block (can only start before any records e.g. if record_num == 0)
  record_num = 0



  hashtag = config[:hashtag]

  if hashtag
    comment = COMMENT_PERCENT
    ## todo/check: use a "heuristic" to check if its a comment or a hashtag line? why? why not?
  else
    ## note: can either use '#' or '%' but NOT both; first one "wins"
    comment = nil
  end


  has_seen_directive   = false
  has_seen_frontmatter = false   ## - renameto  has_seen_dash (---) - why? why not???
  ## note: can either use directives (@) or frontmatter (---) block; first one "wins"

  loop do
    break if input.eof?

    skipped_spaces = skip_spaces( input )

    if comment.nil? && (c=input.peek; c==COMMENT_HASH || c==COMMENT_PERCENT)
      logger.debug "skipping comment (first) - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
      comment = input.getc  ## first comment line (determines/fixes "allowed" comment-style)
      skip_until_eol( input )
      skip_newline( input )
    elsif comment && input.peek == comment        ## (anther) comment line
      logger.debug "skipping comment (follow-up) - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
      skip_until_eol( input )
      skip_newline( input )
    elsif (c=input.peek; c==LF || c==CR || input.eof?)
      logger.debug "skipping blank - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?
      skip_newline( input )
    elsif record_num == 0 && hashtag == false && has_seen_frontmatter == false && input.peek==DIRECTIVE
      ## note: "skip" directives for now
      has_seen_directive = true
      logger.debug "skip directive"  if logger.debug?
      skip_until_eol( input )
      skip_newline( input )
    elsif record_num == 0 && hashtag == false && has_seen_directive == false && has_seen_frontmatter == false &&
          skipped_spaces == 0 && input.peekn(4) =~ /^---[\n\r \t]$/
      ## note: assume "---" (MUST BE) followed by newline (\r or \n) or space starts a meta block
      has_seen_frontmatter = true
      logger.debug "start meta block"  if logger.debug?
      ## note: meta gets stored as object attribute (state/state/state!!)
      ##   use meta attribute to get meta data after reading first record
      @meta = parse_meta( input )   ## note: assumes a hash gets returned
      logger.debug "  meta: >#{meta.inspect}<"  if logger.debug?
    else
      logger.debug "start record - peek >#{input.peek}< (#{input.peek.ord})"  if logger.debug?

      record = parse_record( input, sep: sep )
      record_num +=1

      ## note: requires block - enforce? how? why? why not?
      block.call( record )   ## yield( record )
    end
  end  # loop
end # method parse_lines




def convert_to_float( value ) Float( value ) rescue value; end

def is_nan?( value )
   nan = @config[:nan]
   if nan.nil?
     false  ## nothing set; return always false (not NaN)
   elsif nan.is_a?( Proc )
     nan.call( value )
   elsif nan.is_a?( Array )
     nan.include?( value )
   elsif nan.is_a?( String )
     value == nan
   else  ## unknown config style / setting
     ##  todo: issue a warning or error - why? why not?
     false  ## nothing set; return always false (not nan)
   end
end


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


end # class ParserStd
end # class CsvReader
