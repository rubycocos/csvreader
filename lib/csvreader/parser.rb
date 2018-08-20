# encoding: utf-8

require 'json'
require 'pp'



class BufferIO
	def initialize( data )
		# create the IO object we will read from
	  @io = data.is_a?(String) ? StringIO.new(data) : data
		@c  = nil  ## last char (used for peek)
  end

  def eof?()      @c.nil? && @io.eof?;  end

  def rewind
		@c = nil
		@io.rewind
	end

  def getc
    if @c
			c = @c
			@c = nil  ## reset (buffer) last char
			c
		else
			@io.getc
		end
	end # method getc

	def ungetc( c )
		if @c   ## note: unget peek first if buffered/present
			@io.ungetc( @c )
			@c = nil  ## reset (buffer) last char
		end
		@io.ungetc( c )
	end


  def peek
		 ## todo/fix:
     ## use Hexadecimal code: 1A, U+001A for eof char - why? why not?

		if @c.nil? && @io.eof?
			puts "peek - hitting eof!!!"
			## return eof char(s) - exits? is \0 ?? double check
			return "XX"
		end

    @c = @io.getc   if @c.nil?
		@c
	end # method peek
end # class scanner




class Parser

def self.parse( data )
	puts "parse:"
	pp data

  parser = new
	io = BufferIO.new( data )
	parser.parse( io )
end


def self.parse_line( data )
	puts "parse_line:"

	parser = new
	io = BufferIO.new( data )
	records = parser.parse_lines( io, trim: true, comments: true, blanks: true, limit: 1 )

	## unwrap record if empty return nil - why? why not?
	##  return empty record e.g. [] - why? why not?
	records.size == 0 ? nil : records.first
end




def parse_field( io, trim: true )
  value = ""
	value << parse_spaces( io ) ## add leading spaces

  if (c=io.peek; c=="," || c=="\n" || c=="\r" || io.eof?) ## empty field
		value = value.strip    if trim ## strip all spaces
		 ## return value; do nothing
  elsif io.peek == "\""   ## DOUBLE_QUOTE
		value = value.strip   ## note always strip/trim leading spaces in quoted value

		puts "start double_quote field - peek >#{io.peek}< (#{io.peek.ord})"
		io.getc  ## eat-up double_quote

		loop do
		  while (c=io.peek; !(c=="\"" || io.eof?))
			  value << io.getc   ## eat-up everything unit quote (")
		  end

			break if io.eof?

			io.getc ## eat-up double_quote

			if io.peek == "\""  ## doubled up quote?
				value << io.getc   ## add doube quote and continue!!!!
			else
        break
      end
    end

		## note: always eat-up all trailing spaces (" ") and tabs (\t)
		skip_spaces( io ) unless io.eof?
		puts "end double_quote field - peek >#{io.peek}< (#{io.peek.ord})"
  else
		puts "start reg field - peek >#{io.peek}< (#{io.peek.ord})"
		## consume simple value
    ##   until we hit "," or "\n" or "\r"
		##    note: will eat-up quotes too!!!
    while (c=io.peek; !(c=="," || c=="\n" || c=="\r" || io.eof?))
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
		 elsif (c=io.peek; c=="\n" || c=="\r")
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
	while (c=io.peek; c=="\n" || c=="\r")
		io.getc    ## eat-up all \n and \r
	end
end


def skip_eol( io )
  while (c=io.peek; !(c=="\n" || c=="\r" || io.eof?))
	  io.getc    ## eat-up all until end of line
	end
end

def skip_spaces( io )
  while (c=io.peek; c==" " || c=="\t")
	  io.getc   ## note: always eat-up all spaces (" ") and tabs (\t)
  end
end




def parse_spaces( io )  ## helper method
	spaces = ""
	## add leading spaces
	while (c=io.peek; c==" " || c=="\t")
		spaces << io.getc   ## eat-up all spaces (" ") and tabs (\t)
	end
  spaces
end




def parse_lines( io, trim: true, comments: true, blanks: true, limit: nil )
	records = []
	loop do
    break if io.eof?

    ## hack: use own space buffer for peek( x ) lookahead (more than one char)
    ## check for comments or blank lines
    if comments || blanks
      spaces = parse_spaces( io )
    end

    if comments && io.peek == "#"  			## comment line
			puts "skipping comment - peek >#{io.peek}< (#{io.peek.ord})"
			skip_eol( io )
			skip_newlines( io )  unless io.eof?
    elsif blanks && (c=io.peek; c=="\n" || c=="\r" || io.eof?)
			puts "skipping blank - peek >#{io.peek}< (#{io.peek.ord})"
			skip_newlines( io )  unless io.eof?
    else  # undo (ungetc spaces)
			puts "start record - peek >#{io.peek}< (#{io.peek.ord})"

      if comments || blanks
			  spaces.each_char { |space| io.ungetc( space ) }
			end

			record = parse_record( io, trim: trim )
			records << record

      ## set limit to 1 for processing "single" line (that is, get one record)
			return records   if limit && limit >= records.size
		end
  end  # loop
	records
end # method parse_lines



def parse( io, trim: true, comments: true, blanks: true )
  records = parse_lines( io, trim: trim, comments: comments, blanks: blanks )
  records
end ## method parse


end # class Parser




sample = "a,b,c\n1,2,3\n4,5,6"

## Parser.parse( sample )

sample2 = " a, b ,c  \n 1 , 2 , 3 \n4,5,6  "

## Parser.parse( sample2 )


sample3 = " a, b ,c  \n\"11 \n 11\", \"\"\"2\"\"\" , 3 \n"

sample4 = <<TXT
a, b ,c
 11"11 , 3

   # comment
   # comment
   ## comment

2,3,5
TXT

sample5 = <<TXT
a, b ,c
 "11 "" 11" , The "Golden" Ed. ""
"","",""

   # comment
   # comment
   ## comment

2,3,5
TXT

sample6 = <<TXT

   # comment
   # comment
   ## comment

a, b ,c
11, "12" , "13", " 14 "
" ", "  "
TXT




pp Parser.parse( sample6 )
pp Parser.parse_line( sample6 )

puts "bye"
