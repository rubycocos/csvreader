# encoding: utf-8


class BufferLinePos
  def initialize( data )
    # create the IO object we will read from
    @input = data
    @buf   = "" ## last (buffer) chars (used for peek)
    @pos    = 0
    @length = 0
  end

  def empty?
     @length == 0 || @pos >= @length
  end

  def eof?()  @input.eof? && empty?; end

  def getc
    if empty?
      @buf    = @input.gets
      @length = @buf.length
      @pos    = 0
    end

    ## todo: check - if works for multi-byte chars??
    c = @buf[@pos]
    @pos += 1
    c
  end # method getc


  def peek
    if empty?

      if @input.eof?
        ## puts "peek - hitting eof!!!"
        return  "\0"   ## return NUL char (0) for now
      else
        @buf    = @input.gets
        @length = @buf.length
        @pos    = 0
        ## puts "peek - fill buffer >#{c}< (#{c.ord})"
      end
    end

    ## todo: check - if works for multi-byte chars??
    @buf[@pos]    ## @buf.first
  end # method peek
end # class BufferLinePos
