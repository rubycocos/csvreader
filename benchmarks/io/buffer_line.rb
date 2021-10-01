# encoding: utf-8


class BufferLine
  def initialize( data )
    # create the IO object we will read from
    @input = data
    @buf   = ""  ## last (buffer) chars (used for peek)
  end

  def eof?()   @buf.empty? && @input.eof?;  end

  def getc
    if @buf.empty?
      @buf = @input.gets
    end

    ## todo: check - if works for multi-byte chars??
    @buf.slice!(0)  ## get first char from buffer
  end # method getc


  def peek
    if @buf.empty? && @input.eof?
      ## puts "peek - hitting eof!!!"
      return  "\0"   ## return NUL char (0) for now
    end

    if @buf.empty?
        @buf = @input.gets
        ## puts "peek - fill buffer >#{c}< (#{c.ord})"
    end

    ## todo: check - if works for multi-byte chars??
    @buf[0]    ## @buf.first
  end # method peek
end # class Buffer
