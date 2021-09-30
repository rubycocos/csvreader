# encoding: utf-8

class CsvReader
class Builder


  def initialize( parser )
    @parser = parser
  end


  ## (auto-)forward to wrapped parser
  ##   note/fix: not all parser use/have config e.g. ParserTab, ParserFixed, etc.
  ##
  ## todo/fix:
  ##   add parser config (attribute) setter e.g.
  ##   - sep=(value)
  ##   - comment=(value)
  ##   - and so on!!!
  def config() @parser.config; end



  def open( path, mode=nil, **kwargs, &block )
    CsvReader.open( path, mode, parser: @parser, **kwargs, &block )
  end

  def read( path, **kwargs )
    CsvReader.read( path, parser: @parser, **kwargs )
  end

  def header( path, **kwargs )
    CsvReader.header( path, parser: @parser, **kwargs )
  end

  def foreach( path, **kwargs, &block )
    CsvReader.foreach( path, parser: @parser, **kwargs, &block )
  end


  def parse( str_or_readable, **kwargs, &block )
    CsvReader.parse( str_or_readable, parser: @parser, **kwargs, &block )
  end
end # class Builder
end # class CsvReader



class CsvHashReader
class Builder
  def initialize( parser )
    @parser = parser
  end

  ## (auto-)forward to wrapped parser
  ##   note/fix: not all parser use/have config e.g. ParserTab, ParserFixed, etc.
  ##
  ## todo/fix:
  ##   add parser config (attribute) setter e.g.
  ##   - sep=(value)
  ##   - comment=(value)
  ##   - and so on!!!
  def config() @parser.config; end



  def open( path, mode=nil, **kwargs, &block )
    CsvHashReader.open( path, mode, parser: @parser, **kwargs, &block )
  end

  def read( path, **kwargs )
    CsvHashReader.read( path, parser: @parser, **kwargs )
  end

  def foreach( path, **kwargs, &block )
    CsvHashReader.foreach( path, parser: @parser, **kwargs, &block )
  end


  def parse( str_or_readable, **kwargs, &block )
    CsvHashReader.parse( str_or_readable, parser: @parser, **kwargs, &block )
  end
end # class Builder
end # class CsvHashReader
