# encoding: utf-8

class Buffer
  def initialize( data )
    # create the IO object we will read from
    @input = data
    @buf   = [] ## last (buffer) chars (used for peek)
  end

  def eof?()   @buf.size == 0 && @input.eof?;  end

  def getc
    if @buf.size > 0
      @buf.shift  ## get first char from buffer
    else
      @input.getc
    end
  end # method getc

  def peek
    if @buf.size == 0 && @input.eof?
      ## puts "peek - hitting eof!!!"
      return  "\0"   ## return NUL char (0) for now
    end

    if @buf.size == 0
        c = @input.getc
        @buf.push( c )
        ## puts "peek - fill buffer >#{c}< (#{c.ord})"
    end

    @buf[0]    ## @buf.first
  end # method peek
end # class Buffer
