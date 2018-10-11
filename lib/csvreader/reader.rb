# encoding: utf-8

class CsvReader

    def self.open( path, mode=nil,
                   sep: nil,
                   converters: nil,
                   parser: nil, &block )   ## rename path to filename or name - why? why not?

        ## note: default mode (if nil/not passed in) to 'r:bom|utf-8'
        f = File.open( path, mode ? mode : 'r:bom|utf-8' )
        csv = new(f, sep: sep,
                     converters: converters,
                     parser: parser )

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


    def self.read( path, sep: nil,
                         converters: nil,
                         parser: nil )
        open( path,
              sep: sep,
              converters: converters,
              parser: parser ) { |csv| csv.read }
    end


    def self.header( path, sep: nil, parser: nil )   ## use header or headers - or use both (with alias)?
       # read first lines (only)
       #  and parse with csv to get header from csv library itself

       records = []
       open( path, sep: sep, parser: parser ) do |csv|
          csv.each do |record|
            records << record
            break   ## only parse/read first record
          end
       end

       ## unwrap record if empty return nil - why? why not?
       ##  return empty record e.g. [] - why? why not?
       ##  returns nil for empty (for now) - why? why not?
       records.size == 0 ? nil : records.first
    end  # method self.header


    def self.foreach( path, sep: nil,
                            converters: nil, parser: nil, &block )
      csv = open( path, sep: sep, converters: converters, parser: parser )

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


    def self.parse( data, sep: nil,
                          converters: nil,
                          parser: nil, &block )
      csv = new( data, sep: sep, converters: converters, parser: parser )

      if block_given?
        csv.each( &block )  ## note: caller (responsible) must close file!!! - add autoclose - why? why not?
      else  # slurp contents, if no block is given
        csv.read            ## note: caller (responsible) must close file!!! - add autoclose - why? why not?
      end
    end # method self.parse



    ############################
    ## note: only add parse_line convenience helper for default
    ##   always use parse (do NOT/NOT/NOT use parse_line)  - why? why not?
    ##   todo/fix: remove parse_line!!!
    def self.parse_line( data, sep: nil,
                               converters: nil )
       records = []
       parse( data, sep: sep, converters: converters ) do |record|
         records << record
         break   # only parse first record
       end
       records.size == 0 ? nil : records.first
    end




    def initialize( data, sep: nil, converters: nil, parser: nil )
          raise ArgumentError.new( "Cannot parse nil as CSV" )  if data.nil?
          ## todo: use (why? why not) - raise ArgumentError, "Cannot parse nil as CSV"     if data.nil?

          # create the IO object we will read from
          @io = data.is_a?(String) ? StringIO.new(data) : data

          @sep = sep

          @converters  = Converter.create_converters( converters )

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
       if block_given?
         kwargs = {}
         ## note: only add separator if present/defined (not nil)
         kwargs[:sep] = @sep    if @sep && @parser.respond_to?( :'sep=' )

         ## check array / pipeline of converters is empty (size=0 e.g. is [])
         if @converters.empty?
           @parser.parse( @io, kwargs, &block )
         else
           ## add "post"-processing with converters pipeline
           ##   that is, convert all strings to integer, float, date, ... if wanted
           @parser.parse( @io, kwargs ) do |raw_record|
             record = []
             raw_record.each_with_index do | value, i |
               record << @converters.convert( value, i )
             end
             block.call( record )
           end
         end
       else
         to_enum
       end
     end # method each

     def read() to_a; end # method read

end # class CsvReader
