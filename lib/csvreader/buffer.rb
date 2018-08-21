# encoding: utf-8

class CsvReader
class BufferIO   ## todo: find a better name - why? why not? is really just for reading (keep io?)
  def initialize( data )
    # create the IO object we will read from
    @io = data.is_a?(String) ? StringIO.new(data) : data
    @buf = [] ## last (buffer) chars (used for peek)
  end

  def eof?()   @buf.size == 0 && @io.eof?;  end

  def getc
    if @buf.size > 0
      @buf.shift  ## get first char from buffer
    else
      @io.getc
    end
  end # method getc


  def ungetc( c )
    ## add upfront as first char in buffer
    ##   last in/first out queue!!!!
    @buf.unshift( c )
    ## puts "ungetc - >#{c} (#{c.ord})< => >#{@buf}<"
  end


  def peek
     ## todo/fix:
     ## use Hexadecimal code: 1A, U+001A for eof char - why? why not?
    if @buf.size == 0 && @io.eof?
      puts "peek - hitting eof!!!"
      
## use control-z "\C-z" for now
##   code 1A (hex) ?? or 26 (dec) ?? for now
##  note: in general there's no eof character; it's just a state 
## (e.g. -1 returned by a read function etc.)
##  In unix the symbol is control-d, but in Windows is control-z 
##
##  or use
##  Many binary file types use null padding at the end
## (character \0) although this is not an EOF character per se.  To
## generate a null character, you could do this "\0".
## return eof char(s) - exits? is \0 ?? double check - why? why not?
      return  "\C-z"
    end

    if @buf.size == 0
       c = @io.getc
       @buf.push( c )
       ## puts "peek - fill buffer >#{c}< (#{c.ord})"
    end

    @buf.first
  end # method peek
end # class BufferIO
end # class CsvReader
