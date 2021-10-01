# encoding: utf-8


class BufferLineScanner
  def initialize( data )
    # create the IO object we will read from
    @input = data
    @buf   = StringScanner.new("")  ## last (buffer) chars (used for peek)
  end

  def eof?()   @buf.eos? && @input.eof?;  end

  def getc
    if @buf.eos?
      @buf.string = @input.gets     ## was: StringScanner.new( @input.gets )
    end

    ## todo: check - if works for multi-byte chars??
    @buf.getch
  end # method getc


  def skip( pattern )       @buf.skip( pattern ); end
  def scan( pattern )       @buf.scan( pattern ); end
  def scan_until( pattern ) @buf.scan_until( pattern ); end



  def peek
    if @buf.eos? && @input.eof?
      ## puts "peek - hitting eof!!!"
      return  "\0"   ## return NUL char (0) for now
    end

    if @buf.eos?
       @buf.string = @input.gets    ## was: StringScanner.new( @input.gets )
    end

    ## todo: check - if works for multi-byte chars??
    @buf.peek(1)
  end # method peek
end # class BufferLineScanner
