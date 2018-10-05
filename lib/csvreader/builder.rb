# encoding: utf-8


class CsvBuilder  ## rename to CsvReaderBuilder - why? why not?
  def initialize( parser )
    @parser = parser
  end


  ## todo/fix:
  ##   add parser config (attribute) setter e.g.
  ##   - sep=(value)
  ##   - comment=(value)
  ##   - and so on!!!
  ##
  ##   add config too - why? why not?


  def open( path, mode='r:bom|utf-8',
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
