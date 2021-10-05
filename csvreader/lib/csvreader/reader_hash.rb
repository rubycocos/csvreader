# encoding: utf-8

class CsvHashReader


## add convenience shortcuts / aliases for CsvReader support classes
Parser      = CsvReader::Parser
ParserFixed = CsvReader::ParserFixed
ParserJson  = CsvReader::ParserJson
ParserYaml  = CsvReader::ParserYaml
Converter   = CsvReader::Converter



def self.open( path, mode=nil,
               headers: nil,
               sep: nil,
               converters: nil,
               header_converters: nil,
               parser: nil, **kwargs, &block )   ## rename path to filename or name - why? why not?

    ## note: default mode (if nil/not passed in) to 'r:bom|utf-8'
    f = File.open( path, mode ? mode : 'r:bom|utf-8' )
    csv = new(f, headers: headers,
                 sep: sep,
                 converters: converters,
                 header_converters: header_converters,
                 parser: parser, **kwargs )

    # handle blocks like Ruby's open(), not like the (old old) CSV library
    if block_given?
      begin
        block.call( csv )
      ensure
        csv.close
      end
    else
      csv
    end
end # method self.open


def self.read( path, headers: nil,
                     sep: nil,
                     converters: nil,
                     header_converters: nil,
                     parser: nil,
                     **kwargs )
    open( path,
          headers: headers,
          sep: sep,
          converters: converters,
          header_converters: header_converters,
          parser: parser, **kwargs ) { |csv| csv.read }
end



def self.foreach( path, headers: nil,
                        sep: nil,
                        converters: nil,
                        header_converters: nil,
                        parser: nil, **kwargs, &block )
  csv = open( path,
              headers: headers,
              sep: sep,
              converters: converters,
              header_converters: header_converters,
              parser: parser,
              **kwargs )

  if block_given?
    begin
      csv.each( &block )
    ensure
      csv.close
    end
  else
    csv.to_enum    ## note: caller (responsible) must close file!!!
    ## remove version without block given - why? why not?
    ## use Csv.open().to_enum  or Csv.open().each
    ##   or Csv.new( File.new() ).to_enum or Csv.new( File.new() ).each ???
  end
end # method self.foreach


def self.parse( str_or_readable, headers: nil,
                      sep: nil,
                      converters: nil,
                      header_converters: nil,
                      parser: nil, **kwargs, &block )
  csv = new( str_or_readable,
             headers: headers,
             sep: sep,
             converters: converters,
             header_converters: header_converters,
             parser: parser, **kwargs )

  if block_given?
    csv.each( &block )  ## note: caller (responsible) must close file!!! - add autoclose - why? why not?
  else  # slurp contents, if no block is given
    csv.read            ## note: caller (responsible) must close file!!! - add autoclose - why? why not?
  end
end # method self.parse





def initialize( str_or_readable, headers: nil, sep: nil,
                      converters: nil,
                      header_converters: nil,
                      parser: nil,
                      **kwargs )
      raise ArgumentError.new( "Cannot parse nil as CSV" )  if str_or_readable.nil?
      ## todo: use (why? why not) - raise ArgumentError, "Cannot parse nil as CSV"     if data.nil?

      # create the IO object we will read from
      @io = str_or_readable.is_a?(String) ? StringIO.new(str_or_readable) : str_or_readable

      ## pass in headers as array e.g. ['A', 'B', 'C']
      ##  double check: run header_converters on passed in headers?
      ##    for now - do NOT auto-convert passed in headers - keep them as-is (1:1)
      @names = headers ? headers : nil

      @sep    = sep
      @kwargs = kwargs

      @converters        = Converter.create_converters( converters )
      @header_converters = Converter.create_header_converters( header_converters )

      @parser = parser.nil? ? Parser::DEFAULT : parser
end



### IO and StringIO Delegation ###
extend Forwardable
def_delegators :@io,
               :close, :closed?, :eof, :eof?

 ## add more - why? why not?
 ## def_delegators :@io, :binmode, :binmode?, :close, :close_read, :close_write,
 ##                                :closed?, :eof, :eof?, :external_encoding, :fcntl,
 ##                                :fileno, :flock, :flush, :fsync, :internal_encoding,
 ##                                :ioctl, :isatty, :path, :pid, :pos, :pos=, :reopen,
 ##                                :seek, :stat, :string, :sync, :sync=, :tell, :to_i,
 ##                                :to_io, :truncate, :tty?


 include Enumerable


 def each( &block )

   ## todo/fix:
   ##   add case for headers/names.size != values.size
   ##   - add rest option? for if less headers than values (see python csv.DictReader - why? why not?)
   ##
   ##   handle case with duplicate and empty header names etc.


   if block_given?
     kwargs = {}
     ## note: only add separator if present/defined (not nil)
     ##  todo/fix: change sep keyword to "known" classes!!!!
     kwargs[:sep] = @sep    if @sep && @parser.respond_to?( :'sep=' )

     kwargs[:width] = @kwargs[:width]    if @parser.is_a?( ParserFixed )


     @parser.parse( @io, **kwargs ) do |raw_values|     # sep: sep
        if @names.nil?    ## check for (first) headers row
          if @header_converters.empty?
            @names = raw_values   ## store header row / a.k.a. field/column names
          else
            values = []
            raw_values.each_with_index do |value,i|
              values << @header_converters.convert( value, i )
            end
            @names = values
          end
        else    ## "regular" record
          raw_record = @names.zip( raw_values ).to_h    ## todo/fix: check for more values than names/headers!!!
          if @converters.empty?
            block.call( raw_record )
          else
            ## add "post"-processing with converters pipeline
            ##   that is, convert all strings to integer, float, date, ... if wanted
            record = {}
            raw_record.each do | key, value |
              record[ key ] = @converters.convert( value, key )
            end
            block.call( record )
          end
        end
     end
   else
     to_enum
   end
 end # method each

 def read() to_a; end # method read


end # class CsvHashReader
