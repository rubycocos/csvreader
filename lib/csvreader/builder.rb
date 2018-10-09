# encoding: utf-8


class CsvBuilder  ## rename to CsvReaderBuilder - why? why not?


  def initialize( parser )
    @parser = parser
  end

  def config() @parser.config; end   ## (auto-)forward to wrapped parser

  ## todo/fix:
  ##   add parser config (attribute) setter e.g.
  ##   - sep=(value)
  ##   - comment=(value)
  ##   - and so on!!!

  def open( path, mode=nil,
                 sep: nil,
                 converters: nil,
                 parser: @parser, &block )
      CsvReader.open( path, mode,
                      sep: sep, converters: converters,
                      parser: @parser, &block )
  end

  def read( path, sep: nil,
                  converters: nil )
    CsvReader.read( path,
                  sep: sep, converters: converters,
                  parser: @parser )
  end

  def header( path, sep: nil )
    CsvReader.header( path,
                    sep: sep,
                    parser: @parser )
  end

  def foreach( path, sep: nil,
                     converters: nil, &block )
    CsvReader.foreach( path,
                     sep: sep, converters: converters,
                     parser: @parser, &block )
  end



  def parse( data, sep: nil,
                   converters: nil, &block )
    CsvReader.parse( data,
                   sep: sep, converters: converters,
                   parser: @parser, &block )
  end
end # class CsvBuilder




class CsvHashBuilder  ## rename to CsvHashReaderBuilder - why? why not?
  def initialize( parser )
    @parser = parser
  end

  def config() @parser.config; end   ## (auto-)forward to wrapped parser

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
                 parser: @parser, &block )
      CsvHashReader.open( path, mode,
                      headers: headers, sep: sep, converters: converters,
                      header_converters: header_converters,
                      parser: @parser, &block )
  end

  def read( path, headers: nil,
                  sep: nil,
                  converters: nil,
                  header_converters: nil )
    CsvHashReader.read( path,
                  headers: headers,
                  sep: sep, converters: converters,
                  header_converters: header_converters,
                  parser: @parser )
  end

  def foreach( path, headers: nil,
                     sep: nil,
                     converters: nil,
                     header_converters: nil, &block )
    CsvHashReader.foreach( path,
                     headers: headers,
                     sep: sep, converters: converters,
                     header_converters: header_converters,
                     parser: @parser, &block )
  end


  def parse( data, headers: nil,
                   sep: nil,
                   converters: nil,
                   header_converters: nil, &block )
    CsvHashReader.parse( data,
                   headers: headers,
                   sep: sep, converters: converters,
                   header_converters: header_converters,
                   parser: @parser, &block )
  end
end # class CsvHashBuilder
