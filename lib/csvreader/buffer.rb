# encoding: utf-8

class CsvReader
class Buffer   ## todo: find a better name:
               ##   BufferedReader
               ##   BufferedInput
               ##   BufferI
               ## - why? why not? is really just for reading (keep io?)

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

  def peek
    if @buf.size == 0 && @io.eof?
      ## puts "peek - hitting eof!!!"
      return  "\0"   ## return NUL char (0) for now
    end

    if @buf.size == 0
       c = @io.getc
       @buf.push( c )
       ## puts "peek - fill buffer >#{c}< (#{c.ord})"
    end

    @buf.first
  end # method peek

end # class Buffer
end # class CsvReader
