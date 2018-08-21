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
      ## return eof char(s) - exits? is \0 ?? double check
      return "\0"
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
