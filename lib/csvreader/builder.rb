# encoding: utf-8

class CsvReader
class Builder  ## rename to CsvReaderBuilder - why? why not?


  def initialize( parser )
    @parser = parser
  end


  ## (auto-)forward to wrapped parser
  ##   note/fix: not all parser use/have config e.g. ParserTab, ParserFixed, etc.
  def config() @parser.config; end


  ## todo/fix:
  ##   add parser config (attribute) setter e.g.
  ##   - sep=(value)
  ##   - comment=(value)
  ##   - and so on!!!

  def open( path, mode=nil,
                 sep: nil,
                 converters: nil,
                 width: nil,
                 parser: @parser, &block )
      CsvReader.open( path, mode,
                      sep: sep, converters: converters, width: width,
                      parser: @parser, &block )
  end

  def read( path, sep: nil,
                  converters: nil,
                  width: nil )
    CsvReader.read( path,
                  sep: sep, converters: converters, width: width,
                  parser: @parser )
  end

  def header( path, sep: nil, width: nil )
    CsvReader.header( path,
                    sep: sep, width: width,
                    parser: @parser )
  end

  def foreach( path, sep: nil,
                     converters: nil, width: nil, &block )
    CsvReader.foreach( path,
                     sep: sep, converters: converters, width: width,
                     parser: @parser, &block )
  end



  def parse( data, sep: nil,
                   converters: nil, width: nil, &block )
    CsvReader.parse( data,
                   sep: sep, converters: converters, width: width,
                   parser: @parser, &block )
  end
end # class Builder
end # class CsvReader



class CsvHashReader
class Builder  ## rename to CsvHashReaderBuilder - why? why not?
  def initialize( parser )
    @parser = parser
  end

  ## (auto-)forward to wrapped parser
  ##   note/fix: not all parser use/have config e.g. ParserTab, ParserFixed, etc.
  def config() @parser.config; end

  ## todo/fix:
  ##   add parser config (attribute) setter e.g.
  ##   - sep=(value)
  ##   - comment=(value)
  ##   - and so on!!!


  def open( path, mode=nil,
                 headers: nil,
                 sep: nil,
                 converters: nil,
                 header_converters: nil,
                 width: nil,
                 parser: @parser, &block )
      CsvHashReader.open( path, mode,
                      headers: headers, sep: sep, converters: converters,
                      header_converters: header_converters,
                      width: width,
                      parser: @parser, &block )
  end

  def read( path, headers: nil,
                  sep: nil,
                  converters: nil,
                  header_converters: nil,
                  width: nil )
    CsvHashReader.read( path,
                  headers: headers,
                  sep: sep, converters: converters,
                  header_converters: header_converters,
                  width: width,
                  parser: @parser )
  end

  def foreach( path, headers: nil,
                     sep: nil,
                     converters: nil,
                     header_converters: nil, width: nil, &block )
    CsvHashReader.foreach( path,
                     headers: headers,
                     sep: sep, converters: converters,
                     header_converters: header_converters,
                     width: width,
                     parser: @parser, &block )
  end


  def parse( data, headers: nil,
                   sep: nil,
                   converters: nil,
                   header_converters: nil, width: nil, &block )
    CsvHashReader.parse( data,
                   headers: headers,
                   sep: sep, converters: converters,
                   header_converters: header_converters,
                   width: width,
                   parser: @parser, &block )
  end
end # class Builder
end # class CsvHashReader
