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


  def peekn( lookahead )
    ## todo/check:  use a new method peekstr or match or something
    ##    for more than
      if @buf.size == 0 && @io.eof?
        ## puts "peek - hitting eof!!!"
        return  "\0"   ## return NUL char (0) for now
      end

      while @buf.size < lookahead do
         ## todo/check: add/append NUL char (0) - why? why not?
         break if @io.eof?    ## nothing more to read; break out of filling up buffer

         c = @io.getc
         @buf.push( c )
         ## puts "peek - fill buffer >#{c}< (#{c.ord})"
      end

      @buf[0,lookahead].join
  end


  def peek1
    if @buf.size == 0 && @io.eof?
      ## puts "peek - hitting eof!!!"
      return  "\0"   ## return NUL char (0) for now
    end

    if @buf.size == 0
        c = @io.getc
        @buf.push( c )
        ## puts "peek - fill buffer >#{c}< (#{c.ord})"
    end

    @buf[0]    ## @buf.first
  end # method peek1
  alias :peek :peek1  ## for now alias for peek1



end # class Buffer
end # class CsvReader
