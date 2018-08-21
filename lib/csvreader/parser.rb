# encoding: utf-8

class CsvReader
class Parser


## char constants
DOUBLE_QUOTE = "\""
COMMENT      = "#"    ## use COMMENT_HASH or HASH or ??
SPACE        = " "
TAB          = "\t"
LF	         = "\n"    ## 0A (hex)  10 (dec)
CR	         = "\r"    ## 0D (hex)  13 (dec)


def self.parse( data )
  puts "parse:"
  pp data

  parser = new
  parser.parse( data )
end

def self.parse_line( data )
  puts "parse_line:"

  parser = new
  records = parser.parse( data, limit: 1 )

  ## unwrap record if empty return nil - why? why not?
  ##  return empty record e.g. [] - why? why not?
  records.size == 0 ? nil : records.first
end



def self.read( path )
  parser = new
  File.open( path, 'r:bom|utf-8' ) do |file|
    parser.parse( file )
  end
end

def self.foreach( path, &block )
  parser = new
  File.open( path, 'r:bom|utf-8' ) do |file|
    parser.foreach( file, &block )
  end
end

def self.parse_lines( data, &block )
  parser = new
  parser.parse_lines( data, &block )
end





def parse_field( io, trim: true )
  value = ""
  value << parse_spaces( io ) ## add leading spaces

  if (c=io.peek; c=="," || c==LF || c==CR || io.eof?) ## empty field
    value = value.strip    if trim ## strip all spaces
     ## return value; do nothing
  elsif io.peek == DOUBLE_QUOTE
    puts "start double_quote field - value >#{value}<"
    value = value.strip   ## note always strip/trim leading spaces in quoted value

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
    value = value.strip    if trim ## strip all spaces
    puts "end reg field - peek >#{io.peek}< (#{io.peek.ord})"
  end

  value
end



def parse_record( io, trim: true )
  values = []

  loop do
     value = parse_field( io, trim: trim )
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




def parse_spaces( io )  ## helper method
  spaces = ""
  ## add leading spaces
  while (c=io.peek; c==SPACE || c==TAB)
    spaces << io.getc   ## eat-up all spaces (" ") and tabs (\t)
  end
  spaces
end




def parse_lines( io_maybe, trim: true,
                           comments: true,
                           blanks: true,   &block )

  ## find a better name for io_maybe
  ##   make sure io is a wrapped into BufferIO!!!!!!
  if io_maybe.is_a?( BufferIO )    ### allow (re)use of BufferIO if managed from "outside"
    io = io_maybe
  else
    io = BufferIO.new( io_maybe )
  end


  loop do
    break if io.eof?

    ## hack: use own space buffer for peek( x ) lookahead (more than one char)
    ## check for comments or blank lines
    if comments || blanks
      spaces = parse_spaces( io )
    end

    if comments && io.peek == COMMENT        ## comment line
      puts "skipping comment - peek >#{io.peek}< (#{io.peek.ord})"
      skip_until_eol( io )
      skip_newlines( io )
    elsif blanks && (c=io.peek; c==LF || c==CR || io.eof?)
      puts "skipping blank - peek >#{io.peek}< (#{io.peek.ord})"
      skip_newlines( io )
    else  # undo (ungetc spaces)
      puts "start record - peek >#{io.peek}< (#{io.peek.ord})"

      if comments || blanks
        ## note: MUST ungetc in "reverse" order
        ##   ##   buffer is last in/first out queue!!!!
        spaces.reverse.each_char { |space| io.ungetc( space ) }
      end

      record = parse_record( io, trim: trim )

      ## note: requires block - enforce? how? why? why not?
      block.call( record )   ## yield( record )
    end
  end  # loop
end # method parse_lines




def parse( io_maybe, trim: true,
               comments: true,
               blanks: true,
               limit: nil )
  records = []

  parse_lines( io_maybe, trim: trim, comments: comments, blanks: blanks ) do |record|
    records << record

    ## set limit to 1 for processing "single" line (that is, get one record)
    return records   if limit && limit >= records.size
  end

  records
end ## method parse


def foreach( io_maybe, trim: true,
                 comments: true,
                 blanks: true,    &block )
  parse_lines( io_maybe, trim: trim, comments: comments, blanks: blanks, &block )
end



end # class Parser
end # class CsvReader
