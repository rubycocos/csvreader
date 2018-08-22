# encoding: utf-8

class CsvReader
class Parser


## char constants
DOUBLE_QUOTE = "\""
COMMENT      = "#"      ## use COMMENT_HASH or HASH or ??
SPACE        = " "      ##   \s == ASCII 32 (dec)            =    (Space)
TAB          = "\t"     ##   \t == ASCII 0x09 (hex)          = HT (Tab/horizontal tab)
LF	         = "\n"     ##   \n == ASCII 0x0A (hex) 10 (dec) = LF (Newline/line feed)
CR	         = "\r"     ##   \r == ASCII 0x0D (hex) 13 (dec) = CR (Carriage return)



def self.parse( data, sep:  Csv.config.sep,
                      trim: Csv.config.trim? )
  puts "parse:"
  pp data

  parser = new
  parser.parse( data, sep: sep, trim: trim )
end


def self.parse_line( data, sep:  Csv.config.sep,
                           trim: Csv.config.trim? )
  puts "parse_line:"

  parser = new
  records = parser.parse( data, sep: sep, trim: trim, limit: 1 )

  ## unwrap record if empty return nil - why? why not?
  ##  return empty record e.g. [] - why? why not?
  records.size == 0 ? nil : records.first
end



def self.read( path, sep:  Csv.config.sep,
                     trim: Csv.config.trim? )
  parser = new
  File.open( path, 'r:bom|utf-8' ) do |file|
    parser.parse( file, sep: sep, trim: trim )
  end
end

def self.foreach( path, sep:  Csv.config.sep,
                        trim: Csv.config.trim?, &block )
  parser = new
  File.open( path, 'r:bom|utf-8' ) do |file|
    parser.foreach( file, sep: sep, trim: trim, &block )
  end
end


#### fix!!! remove - replace with parse with (optional) block!!!!!
def self.parse_lines( data, sep:  Csv.config.sep,
                            trim: Csv.config.trim?, &block )
  parser = new
  parser.parse_lines( data, sep: sep, trim: trim, &block )
end





def parse_field( io, sep: ',' )
  value = ""
  skip_spaces( io )   ## strip leading spaces

  if (c=io.peek; c=="," || c==LF || c==CR || io.eof?) ## empty field
     ## return value; do nothing
  elsif io.peek == DOUBLE_QUOTE
    puts "start double_quote field - peek >#{io.peek}< (#{io.peek.ord})"
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
    puts "end double_quote field - peek >#{io.peek}< (#{io.peek.ord})"
  else
    puts "start reg field - peek >#{io.peek}< (#{io.peek.ord})"
    ## consume simple value
    ##   until we hit "," or "\n" or "\r"
    ##    note: will eat-up quotes too!!!
    while (c=io.peek; !(c=="," || c==LF || c==CR || io.eof?))
      puts "  add char >#{io.peek}< (#{io.peek.ord})"
      value << io.getc   ## eat-up all spaces (" ") and tabs (\t)
    end
    value = value.strip   ## strip all trailing spaces
    puts "end reg field - peek >#{io.peek}< (#{io.peek.ord})"
  end

  value
end




def parse_field_strict( io )
  value = ""

  if (c=io.peek; c=="," || c==LF || c==CR || io.eof?) ## empty field
     ## return value; do nothing
  elsif io.peek == DOUBLE_QUOTE
    puts "start double_quote field (strict) - peek >#{io.peek}< (#{io.peek.ord})"
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
    puts "end double_quote field (strict) - peek >#{io.peek}< (#{io.peek.ord})"
  else
    puts "start reg field (strict) - peek >#{io.peek}< (#{io.peek.ord})"
    ## consume simple value
    ##   until we hit "," or "\n" or "\r" or stroy "\"" double quote
    while (c=io.peek; !(c=="," || c==LF || c==CR || c==DOUBLE_QUOTE || io.eof?))
      puts "  add char >#{io.peek}< (#{io.peek.ord})"
      value << io.getc
    end
    puts "end reg field (strict) - peek >#{io.peek}< (#{io.peek.ord})"
  end

  value
end



def parse_record( io, sep: ',' )
  values = []

  loop do
     value = parse_field( io, sep: sep )
     puts "value: »#{value}«"
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


def parse_record_strict( io )
  values = []

  loop do
     value = parse_field_strict( io )
     puts "value: »#{value}«"
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




def parse_lines( io_maybe, sep:  ',',
                           trim: true, &block )

  ##
  ## find a better name for io_maybe
  ##   make sure io is a wrapped into BufferIO!!!!!!
  if io_maybe.is_a?( BufferIO )    ### allow (re)use of BufferIO if managed from "outside"
    io = io_maybe
  else
    io = BufferIO.new( io_maybe )
  end

  ## for now use - trim == false for strict version flag alias
  ##   todo/fix: add strict flag - why? why not?
  strict = trim ? false : true

  if strict
    parse_lines_strict( io, sep: sep, &block )
  else
    parse_lines_human( io, sep: sep, &block )
  end
end  ## parse_lines




def parse_lines_human( io, sep: ',', &block )

  loop do
    break if io.eof?

    skip_spaces( io )

    if io.peek == COMMENT        ## comment line
      puts "skipping comment - peek >#{io.peek}< (#{io.peek.ord})"
      skip_until_eol( io )
      skip_newlines( io )
    elsif (c=io.peek; c==LF || c==CR || io.eof?)
      puts "skipping blank - peek >#{io.peek}< (#{io.peek.ord})"
      skip_newlines( io )
    else
      puts "start record - peek >#{io.peek}< (#{io.peek.ord})"

      record = parse_record( io, sep: sep )
      ## note: requires block - enforce? how? why? why not?
      block.call( record )   ## yield( record )
    end
  end  # loop
end # method parse_lines_human



def parse_lines_strict( io, sep: ',', &block )

  ## no leading and trailing whitespaces trimmed/stripped
  ## no comments skipped
  ## no blanks skipped
  ## - follows strict rules of
  ##  note: this csv format is NOT recommended;
  ##    please, use a format with comments, leading and trailing whitespaces, etc.
  ##    only added for checking compatibility

  loop do
    break if io.eof?

    puts "start record (strict) - peek >#{io.peek}< (#{io.peek.ord})"

    record = parse_record_strict( io, sep: sep )

    ## note: requires block - enforce? how? why? why not?
    block.call( record )   ## yield( record )
  end  # loop
end # method parse_lines_strict





## fix: use csv.defaults in args!!
##   fix: add optional block  - lets you use it like foreach!!!
##    make foreach an alias of parse with block - why? why not?
def parse( io_maybe, sep: ',',
                     trim: true,
                     limit: nil )
  records = []

  parse_lines( io_maybe, sep: sep, trim: trim ) do |record|
    records << record

    ## set limit to 1 for processing "single" line (that is, get one record)
    return records   if limit && limit >= records.size
  end

  records
end ## method parse


## fix: use csv.defaults in args!!
def foreach( io_maybe, sep: ',',
                       trim: true, &block )
  parse_lines( io_maybe, sep: sep, trim: trim, &block )
end


end # class Parser
end # class CsvReader
