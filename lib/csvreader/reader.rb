# encoding: utf-8

class CsvReader

  DEFAULT = CsvBuilder.new( Parser::DEFAULT )
  STRICT  = CsvBuilder.new( Parser::STRICT )
  RFC4180 = CsvBuilder.new( Parser::RFC4180 )
  EXCEL   = CsvBuilder.new( Parser::EXCEL )
  TAB     = CsvBuilder.new( Parser::TAB )

  def self.default()  DEFAULT; end    ## alternative alias for DEFAULT
  def self.strict()   STRICT; end     ## alternative alias for RFC4180
  def self.rfc4180()  RFC4180; end    ## alternative alias for RFC4180
  def self.excel()    EXCEL; end      ## alternative alias for EXCEL
  def self.tab()      TAB; end        ## alternative alias for TAB





#######
##  csv reader

    def self.open( path, mode='r:bom|utf-8',
                   sep: nil,
                   converters: nil,
                   parser: nil, &block )   ## rename path to filename or name - why? why not?
        f = File.open( path, mode )
        csv = new(f, sep: sep, converters: converters, parser: parser )

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

          @sep        = sep
          @converters = converters

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
         kwargs = {
           ##  converters: converters  ## todo: add converters
         }
         ## note: only add separator if present/defined (not nil)
         kwargs[:sep] = @sep    if @sep && @parser.respond_to?( :'sep=' )

         @parser.parse( @io, kwargs, &block )
       else
         to_enum
       end
     end # method each

     def read() to_a; end # method read

end # class CsvReader
