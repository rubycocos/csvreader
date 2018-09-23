

class CsvReader

def self.parse_line( txt, sep:        Csv.config.sep,
                          trim:       Csv.config.trim?,
                          na:         Csv.config.na,
                          dialect:    Csv.config.dialect,
                          converters: nil)
  ## note: do NOT include headers option (otherwise single row gets skipped as first header row :-)
  csv_options = Csv.config.default_options.merge(
                  col_sep: sep
  )
  ## pp csv_options
  Parser.parse_line( txt )  ##, csv_options )
end

def self.parse( txt, sep: Csv.config.sep )
  csv_options = Csv.config.default_options.merge(
                   col_sep: sep
  )
  ## pp csv_options
  Parser.parse( txt )  ###, csv_options )
end

def self.parse_lines( txt, sep: Csv.config.sep, &block )
  csv_options = Csv.config.default_options.merge(
                   col_sep: sep
  )
  ## pp csv_options
  Parser.parse_lines( txt, &block )  ###, csv_options )
end

def self.read( path, sep: Csv.config.sep )
  ## note: use our own file.open
  ##   always use utf-8 for now
  ##    check/todo: add skip option bom too - why? why not?
  txt = File.open( path, 'r:bom|utf-8' ).read
  parse( txt, sep: sep )
end


def self.foreach( path, sep: Csv.config.sep, &block )
  csv_options = Csv.config.default_options.merge(
                   col_sep: sep
  )

  Parser.foreach( path, &block ) ###, csv_options )
end


def self.header( path, sep: Csv.config.sep )   ## use header or headers - or use both (with alias)?
    # read first lines (only)
    #  and parse with csv to get header from csv library itself
    #
    #  check - if there's an easier or built-in way for the csv library

    ## readlines until
    ##  - NOT a comments line or
    ##  - NOT a blank line

   record = nil
   File.open( path, 'r:bom|utf-8' ) do |file|
      record = Parser.parse_line( file )
   end

   record  ## todo/fix: return nil for empty - why? why not?
  end  # method self.header

end # class CsvReader
