# encoding: utf-8


class BufferNum
  def initialize( data )
    # create the IO object we will read from
    @input = data
    @buf   = [] ## last (buffer) chars (used for peek)
  end

  def eof?()   @buf.size == 0 && @input.eof?;  end


  def getc
    if @buf.size > 0
      @buf.shift.chr    ## get first char from buffer (convert back to char/string from ord number/integer)
    else
      @input.getc
    end
  end # method getc

  ## note: peek always returns an integer
  def peek
    if @buf.size == 0

      return 0    if @input.eof?

      c = @input.getc
      @buf.push( c.ord )
      ## puts "peek - fill buffer >#{c}< (#{c.ord})"
   end

    @buf[0]    ## @buf.first
  end # method peek
end # class Buffer
